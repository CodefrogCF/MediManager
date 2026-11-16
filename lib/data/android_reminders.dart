import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/intake_event.dart';
import 'app_database.dart';
import 'reminder_repository.dart';

final class AndroidReminders {
  AndroidReminders(this._db) : settings = ReminderRepository(_db);

  static const dataChanged = 'com.codefrog.medimanager.REMINDER_DATA_CHANGED';
  static const _channel = MethodChannel('medimanager/reminders');

  final AppDatabase _db;
  final ReminderRepository settings;
  final permission = ValueNotifier<bool>(false);
  StreamSubscription<Set<TableUpdate>>? _updates;
  bool _disposed = false;

  void start() {
    _updates = _db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            _db.medications,
            _db.medicationSchedules,
            _db.medicationReminders,
            _db.intakeEvents,
          ]),
        )
        .listen((_) => unawaited(_refresh()));
    unawaited(_refresh());
  }

  void externalChanges() {
    _db.notifyUpdates({TableUpdate.onTable(_db.intakeEvents)});
  }

  void resume() {
    externalChanges();
  }

  Future<void> _refresh() async {
    try {
      // Migrate before asking the receiver in the other process to open SQLite.
      await _db.customSelect('SELECT 1').getSingle();
    } catch (_) {
      return;
    }
    await _updatePermission('refresh');
  }

  Future<void> requestPermission() => _updatePermission('requestPermission');

  Future<void> _updatePermission(String method) async {
    if (_disposed) return;
    final allowed = await _invoke<bool>(method);
    if (!_disposed && allowed != null) permission.value = allowed;
  }

  Future<void> openSettings() async => _invoke<void>('settings');

  Future<bool> snooze(ScheduledIntake intake, int latestEventId) async =>
      await _invoke<bool>('snooze', {
        'schedule': intake.scheduleId,
        'day': intake.scheduledDate.epochDay,
        'event': latestEventId,
      }).timeout(const Duration(seconds: 12), onTimeout: () => false) ??
      false;

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  void dispose() {
    _disposed = true;
    unawaited(_updates?.cancel());
    permission.dispose();
  }
}
