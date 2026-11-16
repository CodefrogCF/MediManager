import 'package:drift/drift.dart';

import 'app_database.dart';

final class ReminderRepository {
  ReminderRepository(this._db, {this._now = DateTime.now});

  static const defaultSnoozeMinutes = 10;
  static const snoozeOptions = [5, 10, 15, 30, 60];

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<SlotReminder?> watch(int scheduleId) =>
      _settings(scheduleId).watchSingleOrNull();

  Future<void> save(
    int scheduleId, {
    required bool enabled,
    required int? reminderMinute,
    required int snoozeMinutes,
  }) => _db.transaction(() async {
    if (reminderMinute != null) {
      RangeError.checkValueInInterval(reminderMinute, 0, 1439);
    }
    RangeError.checkValueInInterval(snoozeMinutes, 1, 120);
    final previous = await _settings(scheduleId).getSingleOrNull();
    if (previous?.enabled == enabled &&
        previous?.reminderMinute == reminderMinute &&
        previous?.snoozeMinutes == snoozeMinutes) {
      return;
    }
    final sameDelivery =
        previous?.enabled == enabled &&
        previous?.reminderMinute == reminderMinute;
    await _db
        .into(_db.slotReminders)
        .insertOnConflictUpdate(
          SlotRemindersCompanion.insert(
            scheduleId: Value(scheduleId),
            enabled: enabled,
            reminderMinute: Value(reminderMinute),
            snoozeMinutes: snoozeMinutes,
            changedAt: sameDelivery ? previous!.changedAt : _now().toUtc(),
          ),
        );
  });

  SimpleSelectStatement<$SlotRemindersTable, SlotReminder> _settings(int id) =>
      _db.select(_db.slotReminders)..where((row) => row.scheduleId.equals(id));
}
