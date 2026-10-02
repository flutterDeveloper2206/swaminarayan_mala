import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme/app_colors.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class DataSettingsScreen extends StatelessWidget {
  const DataSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();

    return SettingsPageScaffold(
      title: l10n.dataSection,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_outlined),
                  title: Text(l10n.exportData),
                  onTap: () => _export(context, state, l10n),
                ),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(l10n.importData),
                  onTap: () => _import(context, state, l10n),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: Text(l10n.resetToday),
                  onTap: () async {
                    final ok = await ConfirmationDialog.show(
                      context,
                      title: l10n.areYouSure,
                      message: l10n.resetTodayConfirm,
                      confirmLabel: l10n.confirm,
                      cancelLabel: l10n.cancel,
                    );
                    if (ok) await state.resetToday();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: AppColors.error),
                  title: Text(l10n.resetAllData),
                  onTap: () async {
                    final ok1 = await ConfirmationDialog.show(
                      context,
                      title: l10n.areYouSure,
                      message: l10n.resetAllConfirm,
                      confirmLabel: l10n.confirm,
                      cancelLabel: l10n.cancel,
                    );
                    if (!ok1 || !context.mounted) return;
                    final ok2 = await ConfirmationDialog.show(
                      context,
                      title: l10n.areYouSure,
                      message: l10n.resetAllConfirm2,
                      confirmLabel: l10n.confirm,
                      cancelLabel: l10n.cancel,
                    );
                    if (ok2) await state.resetAll();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, AppState state, AppLocalizations l10n) async {
    try {
      final json = state.exportBackup();
      final dir = await getTemporaryDirectory();
      final file =
          File('${dir.path}/japnaam_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(json);
      await Share.shareXFiles([XFile(file.path)], text: 'Swaminarayan Maala Backup');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.exportSuccess)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }
    }
  }

  Future<void> _import(BuildContext context, AppState state, AppLocalizations l10n) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final bytes = result.files.first.bytes;
      String content;
      if (bytes != null) {
        content = utf8.decode(bytes);
      } else {
        final path = result.files.first.path;
        if (path == null) throw const FormatException('No file');
        content = await File(path).readAsString();
      }
      await state.importBackup(content);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.importSuccess)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.importFailed)));
      }
    }
  }
}
