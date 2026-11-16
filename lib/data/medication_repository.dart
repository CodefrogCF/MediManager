import 'package:drift/drift.dart';

import '../domain/intake_event.dart';
import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'app_database.dart';

typedef DailyIntake = ({
  Medication medication,
  MedicationSchedule schedule,
  ScheduledIntake intake,
});

final class MedicationRepository {
  MedicationRepository(this._db, {this._now = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _now;

  LocalDate get today => LocalDate.fromDateTime(_now().toLocal());

  Stream<List<Medication>> watchMedications() =>
      (_db.select(_db.medications)..orderBy([
            (row) => OrderingTerm.asc(row.name),
            (row) => OrderingTerm.asc(row.id),
          ]))
          .watch();

  Stream<Medication?> watchMedication(int id) =>
      _medication(id).watchSingleOrNull();

  Future<int> createMedication({required String name, String? dosage}) {
    return _db
        .into(_db.medications)
        .insert(
          MedicationsCompanion.insert(
            name: _requiredName(name),
            dosage: Value(_optionalText(dosage)),
            createdAt: _now().toUtc(),
          ),
        );
  }

  Future<void> updateMedication(
    int id, {
    required String name,
    String? dosage,
  }) async {
    final changed =
        await (_db.update(
          _db.medications,
        )..where((row) => row.id.equals(id))).write(
          MedicationsCompanion(
            name: Value(_requiredName(name)),
            dosage: Value(_optionalText(dosage)),
          ),
        );
    if (changed == 0) throw StateError('Medication no longer exists');
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

  Stream<List<DailyIntake>> watchDailyIntakes(LocalDate date) {
    final schedules = _db.medicationSchedules;
    final medications = _db.medications;
    final day = date.epochDay;
    final query =
        _db.select(schedules).join([
            innerJoin(
              medications,
              medications.id.equalsExp(schedules.medicationId),
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
            OrderingTerm.asc(medications.name),
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

    if (replacesScheduleId != null) {
      final old = await (_schedules(
        medicationId,
      )..where((row) => row.id.equals(replacesScheduleId))).getSingle();
      final boundary = await _changeBoundary(old, date);
      final end = old.endsBefore;
      final canReschedule =
          date.isBefore(old.startsOn) && boundary == old.startsOn;
      if ((end != null && !boundary.isBefore(end)) ||
          (!canReschedule && startsOn != boundary)) {
        throw StateError('Schedule cannot be replaced on this date');
      }
      await _endSchedule(old.id, boundary);
    }

    return _db
        .into(_db.medicationSchedules)
        .insert(
          MedicationSchedulesCompanion.insert(
            medicationId: medicationId,
            recurrence: recurrence,
            minutesAfterMidnight: Value(minutesAfterMidnight),
            startsOn: startsOn,
            endsBefore: Value(endsBefore),
          ),
        );
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
