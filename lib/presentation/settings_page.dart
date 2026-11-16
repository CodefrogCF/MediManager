import 'package:flutter/material.dart';

import '../data/android_reminders.dart';
import '../data/backup_repository.dart';
import '../data/settings_repository.dart';
import 'data_privacy_page.dart';
import 'labels.dart';

enum AppAccent {
  green(Color(0xFF00A331)),
  blue(Colors.blue),
  teal(Colors.teal),
  orange(Colors.orange),
  purple(Colors.purple),
  red(Colors.red);

  const AppAccent(this.color);

  final Color color;

  String label(BuildContext context) => switch (this) {
    green => context.l10n.greenAccent,
    blue => context.l10n.blueAccent,
    teal => context.l10n.tealAccent,
    orange => context.l10n.orangeAccent,
    purple => context.l10n.purpleAccent,
    red => context.l10n.redAccent,
  };
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.repository,
    this.backup,
    this.reminders,
    super.key,
  });

  final SettingsRepository repository;
  final BackupRepository? backup;
  final AndroidReminders? reminders;

  Future<void> _save(
    BuildContext context, {
    String? themeMode,
    String? accent,
    String? language,
  }) async {
    try {
      await repository.save(
        themeMode: themeMode,
        accent: accent,
        language: language,
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: StreamBuilder(
        stream: repository.watch,
        builder: (context, snapshot) {
          final settings = snapshot.data ?? SettingsRepository.defaults;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (snapshot.hasError) ListTile(title: Text(l10n.loadError)),
              _Heading(l10n.appearance),
              _Setting(
                title: l10n.themeMode,
                selected: settings.themeMode,
                options: {
                  'system': l10n.systemTheme,
                  'light': l10n.lightTheme,
                  'dark': l10n.darkTheme,
                },
                onChanged: (value) => _save(context, themeMode: value),
              ),
              _Setting(
                title: l10n.accentColor,
                selected: settings.accent,
                options: {
                  for (final accent in AppAccent.values)
                    accent.name: accent.label(context),
                },
                onChanged: (value) => _save(context, accent: value),
              ),
              _Setting(
                title: l10n.language,
                selected: settings.language,
                options: const {'de': 'Deutsch', 'en': 'English'},
                onChanged: (value) => _save(context, language: value),
              ),
              const Divider(),
              if (reminders case final reminders?)
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.notificationSettings),
                  onTap: reminders.openSettings,
                ),
              if (backup case final backup?)
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(l10n.dataAndPrivacy),
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => DataPrivacyPage(repository: backup),
                    ),
                  ),
                ),
              const Divider(),
              _Heading(l10n.about),
              ListTile(
                title: Text(l10n.app),
                subtitle: Text(l10n.appVersion('0.3.0')),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Semantics(
      header: true,
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _Setting extends StatelessWidget {
  const _Setting({
    required this.title,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final String selected;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: Text(options[selected]!),
    trailing: const Icon(Icons.expand_more),
    onTap: () async {
      final value = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(title),
          children: [
            for (final option in options.entries)
              ListTile(
                title: Text(option.value),
                selected: option.key == selected,
                trailing: option.key == selected
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, option.key),
              ),
          ],
        ),
      );
      if (context.mounted && value != null && value != selected) {
        onChanged(value);
      }
    },
  );
}
