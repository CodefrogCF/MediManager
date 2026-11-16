import 'package:drift/drift.dart';

import 'app_database.dart';

final class ReminderRepository {
  ReminderRepository(this._db, {this._now = DateTime.now});

  static const defaultSnoozeMinutes = 10;
  static const snoozeOptions = [5, 10, 15, 30, 60];

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<MedicationReminder?> watch(int medicationId) =>
      _settings(medicationId).watchSingleOrNull();

  Future<void> save(
    int medicationId, {
    required bool enabled,
    required int? reminderMinute,
    required int snoozeMinutes,
  }) => _db.transaction(() async {
    if (reminderMinute != null) {
      RangeError.checkValueInInterval(reminderMinute, 0, 1439);
    }
    if (!snoozeOptions.contains(snoozeMinutes)) {
      throw ArgumentError.value(snoozeMinutes, 'snoozeMinutes');
    }
    final previous = await _settings(medicationId).getSingleOrNull();
    if (previous?.enabled == enabled &&
        previous?.reminderMinute == reminderMinute &&
        previous?.snoozeMinutes == snoozeMinutes) {
      return;
    }
    final sameDelivery =
        previous?.enabled == enabled &&
        previous?.reminderMinute == reminderMinute;
    await _db
        .into(_db.medicationReminders)
        .insertOnConflictUpdate(
          MedicationRemindersCompanion.insert(
            medicationId: Value(medicationId),
            enabled: enabled,
            reminderMinute: Value(reminderMinute),
            snoozeMinutes: snoozeMinutes,
            changedAt: sameDelivery ? previous!.changedAt : _now().toUtc(),
          ),
        );
  });

  SimpleSelectStatement<$MedicationRemindersTable, MedicationReminder>
  _settings(int id) =>
      _db.select(_db.medicationReminders)
        ..where((row) => row.medicationId.equals(id));
}
