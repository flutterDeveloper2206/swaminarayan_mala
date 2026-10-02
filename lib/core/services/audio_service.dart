import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../constants/asset_constants.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _fxPlayer = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();
  bool _ready = false;
  bool _ambientPlaying = false;
  String? _activeSourceKey;
  String _activeMode = AppConstants.ambientModeLoop;
  StreamSubscription<void>? _completeSub;

  Future<void> init() async {
    try {
      await _fxPlayer.setReleaseMode(ReleaseMode.stop);
      await _fxPlayer.setVolume(0.25);
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(0.35);
      _completeSub?.cancel();
      _completeSub = _ambientPlayer.onPlayerComplete.listen((_) {
        // once mode: track finished; loop/continue use ReleaseMode.loop
        _ambientPlaying = false;
      });
      _ready = true;
    } catch (e) {
      debugPrint('AudioService init: $e');
      _ready = false;
    }
  }

  Future<void> playTap({required bool enabled}) async {
    if (!enabled || !_ready) return;
    try {
      await _fxPlayer.stop();
      await _fxPlayer.play(AssetSource(AssetConstants.tapSound.replaceFirst('assets/', '')));
    } catch (_) {}
  }

  Future<void> playMalaComplete({required bool enabled}) async {
    if (!enabled || !_ready) return;
    try {
      await _fxPlayer.stop();
      await _fxPlayer.play(
        AssetSource(AssetConstants.malaCompleteSound.replaceFirst('assets/', '')),
      );
    } catch (_) {}
  }

  Future<void> playTargetComplete({required bool enabled}) async {
    if (!enabled || !_ready) return;
    try {
      await _fxPlayer.stop();
      await _fxPlayer.play(
        AssetSource(AssetConstants.targetCompleteSound.replaceFirst('assets/', '')),
      );
    } catch (_) {}
  }

  /// [customPath] non-empty → DeviceFileSource; else bundled default asset.
  /// [mode]: loop | once | continue (continue loops while foreground).
  Future<void> startAmbient({
    required bool enabled,
    double volume = 0.35,
    String? customPath,
    String mode = AppConstants.ambientModeLoop,
    bool forceRestart = false,
  }) async {
    if (!_ready) return;
    if (!enabled) {
      await stopAmbient();
      return;
    }

    final path = customPath?.trim() ?? '';
    final sourceKey = path.isNotEmpty ? 'file:$path' : 'asset:${AssetConstants.defaultAmbientMusic}';
    final normalizedMode = _normalizeMode(mode);

    if (_ambientPlaying &&
        !forceRestart &&
        _activeSourceKey == sourceKey &&
        _activeMode == normalizedMode) {
      await setAmbientVolume(volume);
      return;
    }

    try {
      await _ambientPlayer.stop();
      _ambientPlaying = false;

      final releaseMode = normalizedMode == AppConstants.ambientModeOnce
          ? ReleaseMode.release
          : ReleaseMode.loop;
      await _ambientPlayer.setReleaseMode(releaseMode);
      await _ambientPlayer.setVolume(volume.clamp(0.0, 1.0));

      if (path.isNotEmpty && File(path).existsSync()) {
        await _ambientPlayer.play(DeviceFileSource(path));
      } else {
        await _ambientPlayer.play(
          AssetSource(AssetConstants.defaultAmbientMusic.replaceFirst('assets/', '')),
        );
      }
      _activeSourceKey = sourceKey;
      _activeMode = normalizedMode;
      _ambientPlaying = true;
    } catch (e) {
      debugPrint('Ambient play failed: $e');
      _ambientPlaying = false;
    }
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

  Future<void> setAmbientVolume(double volume) async {
    if (!_ready) return;
    await _ambientPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> stopAmbient() async {
    if (!_ready) return;
    try {
      await _ambientPlayer.stop();
    } catch (_) {}
    _ambientPlaying = false;
  }

  Future<void> dispose() async {
    await _completeSub?.cancel();
    _completeSub = null;
    await stopAmbient();
    await _fxPlayer.dispose();
    await _ambientPlayer.dispose();
  }
}
