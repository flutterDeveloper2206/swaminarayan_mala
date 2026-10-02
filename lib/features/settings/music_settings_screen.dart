import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class MusicSettingsScreen extends StatelessWidget {
  const MusicSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final s = state.settings;
    final sourceLabel = s.hasCustomAmbient
        ? _displayName(s.ambientMusicPath)
        : l10n.defaultAmbientTrack;

    return SettingsPageScaffold(
      title: l10n.musicSection,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.backgroundMusic),
                  subtitle: Text(l10n.appSlogan),
                  value: s.backgroundMusicEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => state.updateSettings(
                    s.copyWith(backgroundMusicEnabled: v),
                  ),
                ),
                if (s.backgroundMusicEnabled) ...[
                  ListTile(
                    title: Text(l10n.musicVolume),
                    subtitle: Slider(
                      value: s.backgroundMusicVolume.clamp(0.0, 1.0),
                      min: 0,
                      max: 1,
                      divisions: 10,
                      activeColor: AppColors.primary,
                      label: '${(s.backgroundMusicVolume * 100).round()}%',
                      onChanged: (v) {
                        state.updateSettings(
                          s.copyWith(backgroundMusicVolume: v),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.ambientTrack),
                    subtitle: Text(sourceLabel),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _import(context, state, l10n),
                            icon: const Icon(Icons.folder_open_rounded, size: 18),
                            label: Text(l10n.chooseAmbientFile),
                          ),
                        ),
                        if (s.hasCustomAmbient) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await state.resetAmbientMusicToDefault();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.ambientResetDone)),
                                  );
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: Text(l10n.useDefaultAmbient),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.ambientPlaybackMode),
                    subtitle: Text(l10n.ambientPlaybackModeHint),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: SegmentedButton<String>(
                            showSelectedIcon: false,
                            style: const ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            segments: [
                              ButtonSegment(
                                value: AppConstants.ambientModeLoop,
                                label: Text(l10n.ambientModeLoop),
                              ),
                              ButtonSegment(
                                value: AppConstants.ambientModeOnce,
                                label: Text(l10n.ambientModeOnce),
                              ),
                              ButtonSegment(
                                value: AppConstants.ambientModeContinue,
                                label: Text(l10n.ambientModeContinue),
                              ),
                            ],
                            selected: {_normalizeMode(s.ambientPlaybackMode)},
                            onSelectionChanged: (set) {
                              if (set.isEmpty) return;
                              state.setAmbientPlaybackMode(set.first);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _normalizeMode(String mode) {
    switch (mode) {
      case AppConstants.ambientModeOnce:
      case AppConstants.ambientModeContinue:
        return mode;
      default:
        return AppConstants.ambientModeLoop;
    }
  }

  String _displayName(String path) {
    final name = path.split(Platform.pathSeparator).last;
    return name.isEmpty ? path : name;
  }

  Future<void> _import(
    BuildContext context,
    AppState state,
    AppLocalizations l10n,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['mp3', 'm4a', 'wav', 'aac'],
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final path = file.path;
      if (path == null || path.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.ambientImportFailed)),
          );
        }
        return;
      }
      final ok = await state.importAmbientMusic(path, originalName: file.name);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.ambientImportSuccess : l10n.ambientImportFailed),
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.ambientImportFailed)),
        );
      }
    }
  }
}
