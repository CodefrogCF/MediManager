import 'package:drift/drift.dart';

import '../domain/intake_event.dart';
import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'app_database.dart';

typedef DailyIntake = ({
  Medication medication,
  MedicationSchedule schedule,
  ScheduledIntake intake,
  MedicationDetail details,
  IntakeEvent? latestEvent,
  SlotReminder? reminder,
});

typedef MedicationPlan = ({
  MedicationSchedule schedule,
  LocalDate? previousEnd,
});

final class MedicationRepository {
  MedicationRepository(this._db, {this._now = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _now;

  DateTime get localNow => _now().toLocal();
  LocalDate get today => LocalDate.fromDateTime(localNow);

  Stream<List<Medication>> watchMedications() =>
      (_db.select(_db.medications)..orderBy([
            (row) => OrderingTerm.asc(row.name),
            (row) => OrderingTerm.asc(row.id),
          ]))
          .watch();

  Stream<Medication?> watchMedication(int id) =>
      _medication(id).watchSingleOrNull();

  Future<int> createMedication({required String name, String? dosage}) {
    final trimmedName = _requiredName(name);
    final trimmedDosage = _optionalText(dosage);
    return _db.transaction(() async {
      final id = await _db
          .into(_db.medications)
          .insert(
            MedicationsCompanion.insert(
              name: trimmedName,
              dosage: Value(trimmedDosage),
              createdAt: _now().toUtc(),
            ),
          );
      await _saveDetails(
        id,
        AppDatabase.initialDetailsDate,
        trimmedName,
        trimmedDosage,
      );
      return id;
    });
  }

  Future<void> updateMedication(
    int id, {
    required String name,
    String? dosage,
  }) => _db.transaction(() async {
    final trimmedName = _requiredName(name);
    final trimmedDosage = _optionalText(dosage);
    final medication = await _medication(id).getSingle();
    if (medication.name == trimmedName && medication.dosage == trimmedDosage) {
      return;
    }

    await (_db.update(
      _db.medications,
    )..where((row) => row.id.equals(id))).write(
      MedicationsCompanion(
        name: Value(trimmedName),
        dosage: Value(trimmedDosage),
      ),
    );

    final schedules = _db.medicationSchedules;
    final events = _db.intakeEvents;
    final details = _db.medicationDetails;
    final lastRecorded =
        await (_db.selectOnly(events).join([
                innerJoin(schedules, schedules.id.equalsExp(events.scheduleId)),
              ])
              ..addColumns([events.scheduledDate])
              ..where(schedules.medicationId.equals(id))
              ..orderBy([OrderingTerm.desc(events.scheduledDate)])
              ..limit(1))
            .getSingleOrNull();
    final latestDetails =
        await (_db.select(details)
              ..where((row) => row.medicationId.equals(id))
              ..orderBy([(row) => OrderingTerm.desc(row.startsOn)])
              ..limit(1))
            .getSingle();

    // Keep past dates and any previously recorded occurrence stable.
    final lastDate = lastRecorded?.read(events.scheduledDate);
    final startsOn = [
      today,
      if (lastDate != null) LocalDate.fromEpochDay(lastDate).plusDays(1),
      latestDetails.startsOn,
    ].reduce((a, b) => a.isBefore(b) ? b : a);
    await _saveDetails(id, startsOn, trimmedName, trimmedDosage);
  });

  Future<void> _saveDetails(
    int id,
    LocalDate startsOn,
    String name,
    String? dosage,
  ) async {
    await _db
        .into(_db.medicationDetails)
        .insertOnConflictUpdate(
          MedicationDetailsCompanion.insert(
            medicationId: id,
            startsOn: startsOn,
            name: name,
            dosage: Value(dosage),
          ),
        );
  }

  /// Only an unused medication can be permanently deleted.
  Future<bool> deleteMedication(int id) => _db.transaction(() async {
    final schedule = await (_schedules(id)..limit(1)).getSingleOrNull();
    if (schedule != null) return false;
    await (_db.delete(_db.medications)..where((row) => row.id.equals(id))).go();
    return true;
  });

  Future<void> setActive(int id, bool active) => _db.transaction(() async {
    final medication = await _medication(id).getSingle();
    if (medication.isActive == active) return;

    if (!active) {
      final date = today;
      final schedules = await _schedules(id).get();
      for (final schedule in schedules.where((plan) => plan.canChange(date))) {
        final boundary = await _changeBoundary(schedule, date);
        final end = schedule.endsBefore;
        if (end == null || boundary.isBefore(end)) {
          await _endSchedule(schedule.id, boundary);
        }
      }
    }

    await (_db.update(_db.medications)..where((row) => row.id.equals(id)))
        .write(MedicationsCompanion(isActive: Value(active)));
  });

  Stream<List<MedicationSchedule>> watchSchedules(int medicationId) =>
      (_schedules(medicationId)..orderBy([
            (row) => OrderingTerm.asc(row.startsOn),
            (row) => OrderingTerm.asc(row.id),
          ]))
          .watch();

  Stream<List<MedicationPlan>> watchPlans(int medicationId) =>
      watchSchedules(medicationId).map((schedules) {
        final plans = <int, MedicationPlan>{};
        // The schedules are ordered by effective date, then version ID.
        for (final schedule in schedules) {
          final previous = plans[schedule.logicalId]?.schedule;
          plans[schedule.logicalId] = (
            schedule: schedule,
            previousEnd: previous?.endsBefore,
          );
        }
        return plans.values.toList();
      });

  Stream<List<DailyIntake>> watchDailyIntakes(LocalDate date) {
    final schedules = _db.medicationSchedules;
    final medications = _db.medications;
    final details = _db.medicationDetails;
    final events = _db.intakeEvents;
    final reminders = _db.slotReminders;
    final day = date.epochDay;
    final earlierEvents = _db.alias(events, 'earlier_events');
    final latestEventId = _db.selectOnly(earlierEvents)
      ..addColumns([earlierEvents.id])
      ..where(
        earlierEvents.scheduleId.equalsExp(schedules.id) &
            earlierEvents.scheduledDate.equals(day),
      )
      ..orderBy([OrderingTerm.desc(earlierEvents.id)])
      ..limit(1);
    final query =
        _db.select(schedules).join([
            innerJoin(
              medications,
              medications.id.equalsExp(schedules.medicationId),
            ),
            innerJoin(
              details,
              _db.detailsOn(schedules.medicationId, Variable(day)),
            ),
            leftOuterJoin(
              events,
              events.id.equalsExp(subqueryExpression(latestEventId)),
            ),
            leftOuterJoin(
              reminders,
              reminders.scheduleId.equalsExp(schedules.id),
            ),
          ])
          ..where(
            schedules.startsOn.isSmallerOrEqualValue(day) &
                (schedules.endsBefore.isNull() |
                    schedules.endsBefore.isBiggerThanValue(day)),
          )
          ..orderBy([
            OrderingTerm.asc(
              schedules.minutesAfterMidnight,
              nulls: NullsOrder.last,
            ),
            OrderingTerm.asc(details.name),
            OrderingTerm.asc(schedules.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          if (row.readTable(schedules) case final plan when plan.occursOn(date))
            (
              medication: row.readTable(medications),
              schedule: plan,
              intake: (scheduleId: plan.id, scheduledDate: date),
              details: row.readTable(details),
              latestEvent: row.readTableOrNull(events),
              reminder: row.readTableOrNull(reminders),
            ),
      ],
    );
  }

  Future<int> saveSchedule({
    required int medicationId,
    int? replacesScheduleId,
    required Recurrence recurrence,
    required int? minutesAfterMidnight,
    required LocalDate startsOn,
    required LocalDate? endsBefore,
    String? label,
  }) => _db.transaction(() async {
    final date = today;
    if (startsOn.isBefore(date) ||
        (endsBefore != null && !startsOn.isBefore(endsBefore))) {
      throw ArgumentError('Invalid effective dates');
    }
    if (minutesAfterMidnight != null) {
      RangeError.checkValueInInterval(minutesAfterMidnight, 0, 1439);
    }
    if (!(await _medication(medicationId).getSingle()).isActive) {
      throw StateError('Medication is inactive');
    }

    final name = _optionalText(label);
    int? planId;
    if (replacesScheduleId != null) {
      final old = await (_schedules(
        medicationId,
      )..where((row) => row.id.equals(replacesScheduleId))).getSingle();
      final versions =
          await (_schedules(medicationId)
                ..where(
                  (row) =>
                      row.id.equals(old.logicalId) |
                      row.planId.equals(old.logicalId),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.id)]))
              .get();
      if (versions.last.id != old.id) {
        throw StateError('Plan has already been edited');
      }
      final previousEnd = versions.length > 1
          ? versions[versions.length - 2].endsBefore
          : null;
      final boundary = await _changeBoundary(old, date);
      final end = old.endsBefore;
      final canReschedule =
          date.isBefore(old.startsOn) && boundary == old.startsOn;
      if ((end != null && !boundary.isBefore(end)) ||
          (!canReschedule && startsOn != boundary) ||
          (previousEnd != null && startsOn.isBefore(previousEnd))) {
        throw StateError('Schedule cannot be replaced on this date');
      }
      if (recurrence.weekdayMask == old.recurrence.weekdayMask &&
          minutesAfterMidnight == old.minutesAfterMidnight &&
          name == old.label &&
          endsBefore == end &&
          (!canReschedule || startsOn == old.startsOn)) {
        return old.id;
      }
      if (canReschedule) {
        await (_db.update(
          _db.medicationSchedules,
        )..where((row) => row.id.equals(old.id))).write(
          MedicationSchedulesCompanion(
            recurrence: Value(recurrence),
            minutesAfterMidnight: Value(minutesAfterMidnight),
            startsOn: Value(startsOn),
            endsBefore: Value(endsBefore),
            label: Value(name),
          ),
        );
        return old.id;
      }
      planId = old.logicalId;
      await _endSchedule(old.id, boundary);
    }

    final id = await _db
        .into(_db.medicationSchedules)
        .insert(
          MedicationSchedulesCompanion.insert(
            medicationId: medicationId,
            recurrence: recurrence,
            minutesAfterMidnight: Value(minutesAfterMidnight),
            startsOn: startsOn,
            endsBefore: Value(endsBefore),
            label: Value(name),
            planId: Value(planId),
          ),
        );
    if (replacesScheduleId != null) {
      final settings =
          await (_db.select(_db.slotReminders)
                ..where((row) => row.scheduleId.equals(replacesScheduleId)))
              .getSingleOrNull();
      if (settings != null) {
        await _db
            .into(_db.slotReminders)
            .insert(settings.copyWith(scheduleId: id));
      }
    }
    return id;
  });

  Future<void> stopSchedule(int id) => _db.transaction(() async {
    final schedule = await (_db.select(
      _db.medicationSchedules,
    )..where((row) => row.id.equals(id))).getSingle();
    final boundary = await _changeBoundary(schedule, today);
    final end = schedule.endsBefore;
    if (end == null || boundary.isBefore(end)) {
      await _endSchedule(id, boundary);
    }
  });

  SimpleSelectStatement<$MedicationsTable, Medication> _medication(int id) =>
      _db.select(_db.medications)..where((row) => row.id.equals(id));

  SimpleSelectStatement<$MedicationSchedulesTable, MedicationSchedule>
  _schedules(int medicationId) =>
      _db.select(_db.medicationSchedules)
        ..where((row) => row.medicationId.equals(medicationId));

  Future<LocalDate> _changeBoundary(
    MedicationSchedule schedule,
    LocalDate date,
  ) async {
    final boundary = schedule.changeBoundary(date);
    // A clock or time-zone change can put an already recorded date ahead of today.
    final lastEvent =
        await (_db.select(_db.intakeEvents)
              ..where((row) => row.scheduleId.equals(schedule.id))
              ..orderBy([(row) => OrderingTerm.desc(row.scheduledDate)])
              ..limit(1))
            .getSingleOrNull();
    final lastDate = lastEvent?.scheduledDate;
    return lastDate != null && !lastDate.isBefore(boundary)
        ? lastDate.plusDays(1)
        : boundary;
  }

  Future<void> _endSchedule(int id, LocalDate boundary) async {
    await (_db.update(_db.medicationSchedules)
          ..where((row) => row.id.equals(id)))
        .write(MedicationSchedulesCompanion(endsBefore: Value(boundary)));
  }

  String _requiredName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Medication name is required');
    return trimmed;
  }

  String? _optionalText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
