import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/jap_widgets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 100,
    this.editable = false,
  });

  final double size;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final path = state.settings.profileImagePath;
    final hasImage = path.isNotEmpty && File(path).existsSync();

    Widget avatar = hasImage
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 3),
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
              ),
            ),
          )
        : DeityImage(
            deityId: state.settings.selectedDeityId,
            size: size,
            selected: true,
          );

    if (!editable) return avatar;

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          avatar,
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final hasImage = state.settings.profileImagePath.isNotEmpty;

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.chooseFromGallery),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pick(context);
                },
              ),
              if (hasImage)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(l10n.removePhoto),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await state.clearProfileImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pick(BuildContext context) async {
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context);
    try {
      // Android Photo Picker (no READ_MEDIA_IMAGES). Gallery source uses system picker.
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (file == null) return;

      final docs = await getApplicationDocumentsDirectory();
      final dest = File('${docs.path}/profile_avatar.jpg');
      await File(file.path).copy(dest.path);
      await state.setProfileImagePath(dest.path);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    }
  }
}
