import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/backup_repository.dart';
import 'backup_picker_options.dart'
    if (dart.library.js_interop) 'backup_picker_options_web.dart';
import 'labels.dart';

class DataPrivacyPage extends StatefulWidget {
  const DataPrivacyPage({required this.repository, super.key});

  final BackupRepository repository;

  @override
  State<DataPrivacyPage> createState() => _DataPrivacyPageState();
}

class _DataPrivacyPageState extends State<DataPrivacyPage> {
  static const _android = MethodChannel('medimanager/backup');

  bool _busy = false;

  Future<void> _export() => _run(() async {
    final data = await widget.repository.export();
    if (!mounted) return;
    final day = DateTime.now().toIso8601String().split('T').first;
    final written = await FilePicker.saveFile(
      fileName: 'medimanager-$day.json',
      bytes: data,
      dialogTitle: context.l10n.exportBackup,
      mimeType: 'application/json',
    );
    if (!mounted) return;
    if (kIsWeb) {
      _message(context.l10n.backupDownloadStarted);
    } else if (written != null) {
      _message(context.l10n.backupSaved);
    }
  });

  Future<void> _restore() => _run(() async {
    final bytes = await _readBackup();
    if (bytes == null || !mounted) return;
    final backup = widget.repository.inspect(bytes);
    final l10n = context.l10n;
    final summary = l10n.backupSummary(
      Labels.timestamp(context, backup.exportedAt),
      backup.medicationCount,
      backup.eventCount,
    );
    if (!await _confirm(
          l10n.restoreTitle,
          '$summary\n\n${l10n.restoreWarning}',
          l10n.restore,
        ) ||
        !mounted) {
      return;
    }
    await widget.repository.restore(backup);
    if (mounted) _message(context.l10n.backupRestored);
  });

  Future<Uint8List?> _readBackup() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        return await _android.invokeMethod<Uint8List>('pickBackup', {
          'maxBytes': BackupRepository.maxBytes,
        });
      } on PlatformException catch (error) {
        if (error.code == 'backup_too_large') {
          throw const BackupException(BackupProblem.tooLarge);
        }
        rethrow;
      }
    }
    final file = await FilePicker.pickFile(
      dialogTitle: context.l10n.importBackup,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      webOptions: backupWebOptions,
    );
    if (file == null || !mounted) return null;
    BackupRepository.checkSize(file.lengthSync() ?? await file.length() ?? 0);
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in file.readAsByteStream()) {
      BackupRepository.checkSize(bytes.length + chunk.length);
      bytes.add(chunk);
    }
    return bytes.takeBytes();
  }

  Future<void> _delete() => _run(() async {
    final l10n = context.l10n;
    if (!await _confirm(
          l10n.deleteAllTitle,
          l10n.deleteAllWarning,
          l10n.delete,
        ) ||
        !mounted) {
      return;
    }
    await widget.repository.deleteAll();
    if (mounted) _message(context.l10n.dataDeleted);
  });

  Future<bool> _confirm(String title, String details, String action) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text(title),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on BackupException catch (error) {
      if (mounted) {
        final l10n = context.l10n;
        _message(switch (error.problem) {
          BackupProblem.invalid => l10n.backupInvalid,
          BackupProblem.unsupported => l10n.backupUnsupported,
          BackupProblem.tooLarge => l10n.backupTooLarge,
        });
      }
    } catch (_) {
      if (mounted) _message(context.l10n.backupOperationFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dataAndPrivacy)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(title: Text(l10n.localPrivacy)),
          ListTile(title: Text(l10n.appProtection)),
          const Divider(),
          ListTile(title: Text(l10n.backupPlaintext)),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.exportBackup),
            enabled: !_busy,
            onTap: _export,
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: Text(l10n.importBackup),
            enabled: !_busy,
            onTap: _restore,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.deleteAllData),
            enabled: !_busy,
            onTap: _delete,
          ),
          if (_busy) ListTile(title: Text(l10n.backupBusy)),
        ],
      ),
    );
  }
}
