import 'package:drift/drift.dart';

import '../domain/intake_event.dart';
import '../domain/local_date.dart';
import '../domain/medication.dart';
import 'app_database.dart';

typedef MedicationIntakeEvent = ({
  IntakeEvent event,
  MedicationSchedule schedule,
  MedicationDetail details,
});

final class IntakeRepository {
  IntakeRepository(this._db, {this._now = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _now;

  Future<List<IntakeEvent>> historyFor(ScheduledIntake intake) =>
      (_eventsFor(intake)..orderBy([(row) => OrderingTerm.asc(row.id)])).get();

  Stream<List<MedicationIntakeEvent>> watchForMedication(int medicationId) {
    final events = _db.intakeEvents;
    final schedules = _db.medicationSchedules;
    final details = _db.medicationDetails;
    final query =
        _db.select(events).join([
            innerJoin(schedules, schedules.id.equalsExp(events.scheduleId)),
            innerJoin(
              details,
              _db.detailsOn(schedules.medicationId, events.scheduledDate),
            ),
          ])
          ..where(schedules.medicationId.equals(medicationId))
          ..orderBy([
            OrderingTerm.desc(events.scheduledDate),
            OrderingTerm.desc(events.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            event: row.readTable(events),
            schedule: row.readTable(schedules),
            details: row.readTable(details),
          ),
      ],
    );
  }

  Future<int> confirm(ScheduledIntake intake, {DateTime? reportedIntakeAt}) =>
      _append(intake, IntakeEventKind.confirmation, reportedIntakeAt);

  Future<int> correct(ScheduledIntake intake, {int? expectedConfirmationId}) =>
      _append(intake, IntakeEventKind.correction, null, expectedConfirmationId);

  Future<int> _append(
    ScheduledIntake intake,
    IntakeEventKind kind,
    DateTime? reportedIntakeAt, [
    int? expectedConfirmationId,
  ]) => _db.transaction(() async {
    final now = _now();
    final recordedOn = LocalDate.fromDateTime(now.toLocal());
    final schedule = await (_db.select(
      _db.medicationSchedules,
    )..where((row) => row.id.equals(intake.scheduleId))).getSingleOrNull();
    if (schedule == null ||
        !schedule.occursOn(intake.scheduledDate) ||
        (kind == IntakeEventKind.confirmation &&
            recordedOn.isBefore(intake.scheduledDate))) {
      throw ArgumentError('The intake is not scheduled for this date');
    }
    final last =
        await (_eventsFor(intake)
              ..orderBy([(row) => OrderingTerm.desc(row.id)])
              ..limit(1))
            .getSingleOrNull();
    final isConfirmed = last?.isConfirmation ?? false;
    if (isConfirmed == (kind == IntakeEventKind.confirmation) ||
        (expectedConfirmationId != null &&
            last?.id != expectedConfirmationId)) {
      throw StateError(
        'The intake already has the requested confirmation state',
      );
    }

    return _db
        .into(_db.intakeEvents)
        .insert(
          IntakeEventsCompanion.insert(
            scheduleId: intake.scheduleId,
            scheduledDate: intake.scheduledDate,
            kind: kind,
            recordedAt: now.toUtc(),
            recordedOn: Value(recordedOn),
            reportedIntakeAt: Value(reportedIntakeAt?.toUtc()),
          ),
        );
  });

  SimpleSelectStatement<$IntakeEventsTable, IntakeEvent> _eventsFor(
    ScheduledIntake intake,
  ) => _db.select(_db.intakeEvents)
    ..where(
      (row) =>
          row.scheduleId.equals(intake.scheduleId) &
          row.scheduledDate.equals(intake.scheduledDate.epochDay),
    );
}
