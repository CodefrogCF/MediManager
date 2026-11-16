import 'app_database.dart';

final class SettingsRepository {
  SettingsRepository(this._db);

  static const defaults = AppSetting(
    id: 1,
    themeMode: 'system',
    accent: 'green',
    language: 'de',
  );

  final AppDatabase _db;

  late final watch = _db.select(_db.appSettings).watchSingleOrNull();

  Future<void> save({String? themeMode, String? accent, String? language}) =>
      _db.transaction(() async {
        final previous =
            await _db.select(_db.appSettings).getSingleOrNull() ?? defaults;
        await _db
            .into(_db.appSettings)
            .insertOnConflictUpdate(
              previous.copyWith(
                themeMode: themeMode,
                accent: accent,
                language: language,
              ),
            );
      });
}
