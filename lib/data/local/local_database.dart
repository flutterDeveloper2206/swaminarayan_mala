import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/mantra_constants.dart';
import '../../core/helpers/date_helper.dart';
import '../../core/helpers/locale_helper.dart';
import '../models/daily_progress_model.dart';
import '../models/favorite_model.dart';
import '../models/jap_session_model.dart';
import '../models/mantra_model.dart';
import '../models/settings_model.dart';

/// Offline Hive-backed store — single source of truth for SwamiNaam data.
class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  final _uuid = const Uuid();

  late Box _settings;
  late Box _mantras;
  late Box _dailyProgress;
  late Box _sessions;
  late Box _favorites;
  late Box _meta;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      _settings = await Hive.openBox(AppConstants.boxSettings);
      _mantras = await Hive.openBox(AppConstants.boxMantras);
      _dailyProgress = await Hive.openBox(AppConstants.boxDailyProgress);
      _sessions = await Hive.openBox(AppConstants.boxSessions);
      _favorites = await Hive.openBox(AppConstants.boxFavorites);
      _meta = await Hive.openBox(AppConstants.boxMeta);

      await _migrateIfNeeded();
      await _seedIfNeeded();
      _initialized = true;
    } catch (e, st) {
      debugPrint('LocalDatabase init error: $e\n$st');
      rethrow;
    }
  }

  Future<void> _migrateIfNeeded() async {
    final version = _meta.get(AppConstants.keyDbVersion, defaultValue: 0) as int;
    // Fresh SwamiNaam — no JapNaam legacy migration required.
    if (version < AppConstants.databaseVersion) {
      await _meta.put(AppConstants.keyDbVersion, AppConstants.databaseVersion);
    }
  }

  Future<void> _seedIfNeeded() async {
    if (_mantras.isEmpty) {
      for (final seed in MantraConstants.seedMantras) {
        final mantra = MantraModel(
          id: seed.id,
          name: seed.name,
          text: seed.text,
          transliteration: seed.transliteration,
          deityId: seed.deityId,
          target: seed.target,
        );
        await _mantras.put(mantra.id, mantra.toMap());
      }
    }

    if (!_settings.containsKey(AppConstants.keyFirstLaunch)) {
      await _settings.put(AppConstants.keyFirstLaunch, false);
      await _settings.put(AppConstants.keySelectedDeity, AppConstants.defaultFocusId);
      await _settings.put(AppConstants.keySelectedMantra, AppConstants.defaultMantraId);
      await _settings.put(AppConstants.keyThemeMode, 'system');
      await _settings.put(AppConstants.keySoundEnabled, false);
      await _settings.put(AppConstants.keyBackgroundMusic, true);
      await _settings.put(AppConstants.keyBackgroundMusicVolume, 0.35);
      await _settings.put(AppConstants.keyAmbientMusicPath, '');
      await _settings.put(
          AppConstants.keyAmbientPlaybackMode, AppConstants.ambientModeLoop);
      await _settings.put(AppConstants.keyHapticEnabled, true);
      await _settings.put(AppConstants.keyVolumeButton, false);
      await _settings.put(AppConstants.keyDailyTarget, AppConstants.defaultDailyTarget);
      await _settings.put(AppConstants.keyLanguage, LocaleHelper.systemLanguageCode());
      await _settings.put(AppConstants.keyUserName, '');
      await _settings.put(AppConstants.keyProfileImage, '');
      await _settings.put(AppConstants.keyNightMode, false);
      await _settings.put(AppConstants.keyFocusMode, false);
      await _settings.put(AppConstants.keyAutoStart, true);
      await _settings.put(AppConstants.keyReminderEnabled, false);
      await _settings.put(AppConstants.keyReminderHour, AppConstants.defaultReminderHour);
      await _settings.put(AppConstants.keyReminderMinute, AppConstants.defaultReminderMinute);
      await _settings.put(AppConstants.keyCurrentStreak, 0);
      await _settings.put(AppConstants.keyLongestStreak, 0);
      await _settings.put(AppConstants.keyLifetimeCount, 0);
      await _settings.put(AppConstants.keyLifetimeMala, 0);
      await _settings.put(AppConstants.keyLifetimeSessions, 0);
      await _settings.put(AppConstants.keyLifetimeDuration, 0);
      await _settings.put(AppConstants.keyBeadPosition, 0);
    }
  }

  // ─── Settings ───────────────────────────────────────────

  SettingsModel getSettings() {
    return SettingsModel(
      firstLaunchCompleted: _settings.get(AppConstants.keyFirstLaunch, defaultValue: false) as bool,
      selectedDeityId: _settings.get(AppConstants.keySelectedDeity, defaultValue: 'swaminarayan') as String,
      selectedMantraId:
          _settings.get(AppConstants.keySelectedMantra, defaultValue: 'mantra_swaminarayan') as String,
      themeMode: _settings.get(AppConstants.keyThemeMode, defaultValue: 'system') as String,
      soundEnabled: _settings.get(AppConstants.keySoundEnabled, defaultValue: false) as bool,
      backgroundMusicEnabled:
          _settings.get(AppConstants.keyBackgroundMusic, defaultValue: true) as bool,
      backgroundMusicVolume:
          (_settings.get(AppConstants.keyBackgroundMusicVolume, defaultValue: 0.35) as num)
              .toDouble(),
      ambientMusicPath:
          _settings.get(AppConstants.keyAmbientMusicPath, defaultValue: '') as String,
      ambientPlaybackMode: _settings.get(AppConstants.keyAmbientPlaybackMode,
          defaultValue: AppConstants.ambientModeLoop) as String,
      hapticEnabled: _settings.get(AppConstants.keyHapticEnabled, defaultValue: true) as bool,
      volumeButtonEnabled: _settings.get(AppConstants.keyVolumeButton, defaultValue: false) as bool,
      dailyTarget:
          _settings.get(AppConstants.keyDailyTarget, defaultValue: AppConstants.defaultDailyTarget)
              as int,
      languageCode: _settings.get(AppConstants.keyLanguage,
              defaultValue: LocaleHelper.systemLanguageCode()) as String,
      userName: _settings.get(AppConstants.keyUserName, defaultValue: '') as String,
      profileImagePath:
          _settings.get(AppConstants.keyProfileImage, defaultValue: '') as String,
      nightMode: _settings.get(AppConstants.keyNightMode, defaultValue: false) as bool,
      focusMode: _settings.get(AppConstants.keyFocusMode, defaultValue: false) as bool,
      autoStartLastMantra: _settings.get(AppConstants.keyAutoStart, defaultValue: true) as bool,
      reminderMode: _settings.get(AppConstants.keyReminderMode, defaultValue: 'normal') as String,
      reminder: ReminderSettingsModel(
        enabled: _settings.get(AppConstants.keyReminderEnabled, defaultValue: false) as bool,
        hour: _settings.get(AppConstants.keyReminderHour,
            defaultValue: AppConstants.defaultReminderHour) as int,
        minute: _settings.get(AppConstants.keyReminderMinute,
            defaultValue: AppConstants.defaultReminderMinute) as int,
        morningEnabled:
            _settings.get(AppConstants.keyReminderMorning, defaultValue: false) as bool,
        afternoonEnabled:
            _settings.get(AppConstants.keyReminderAfternoon, defaultValue: false) as bool,
        eveningEnabled:
            _settings.get(AppConstants.keyReminderEvening, defaultValue: false) as bool,
      ),
    );
  }

  Future<void> saveSettings(SettingsModel s) async {
    await _settings.put(AppConstants.keyFirstLaunch, s.firstLaunchCompleted);
    await _settings.put(AppConstants.keySelectedDeity, s.selectedDeityId);
    await _settings.put(AppConstants.keySelectedMantra, s.selectedMantraId);
    await _settings.put(AppConstants.keyThemeMode, s.themeMode);
    await _settings.put(AppConstants.keySoundEnabled, s.soundEnabled);
    await _settings.put(AppConstants.keyBackgroundMusic, s.backgroundMusicEnabled);
    await _settings.put(AppConstants.keyBackgroundMusicVolume, s.backgroundMusicVolume);
    await _settings.put(AppConstants.keyAmbientMusicPath, s.ambientMusicPath);
    await _settings.put(AppConstants.keyAmbientPlaybackMode, s.ambientPlaybackMode);
    await _settings.put(AppConstants.keyHapticEnabled, s.hapticEnabled);
    await _settings.put(AppConstants.keyVolumeButton, s.volumeButtonEnabled);
    await _settings.put(AppConstants.keyDailyTarget, s.dailyTarget);
    await _settings.put(AppConstants.keyLanguage, s.languageCode);
    await _settings.put(AppConstants.keyUserName, s.userName);
    await _settings.put(AppConstants.keyProfileImage, s.profileImagePath);
    await _settings.put(AppConstants.keyNightMode, s.nightMode);
    await _settings.put(AppConstants.keyFocusMode, s.focusMode);
    await _settings.put(AppConstants.keyAutoStart, s.autoStartLastMantra);
    await _settings.put(AppConstants.keyReminderMode, s.reminderMode);
    await _settings.put(AppConstants.keyReminderEnabled, s.reminder.enabled);
    await _settings.put(AppConstants.keyReminderHour, s.reminder.hour);
    await _settings.put(AppConstants.keyReminderMinute, s.reminder.minute);
    await _settings.put(AppConstants.keyReminderMorning, s.reminder.morningEnabled);
    await _settings.put(AppConstants.keyReminderAfternoon, s.reminder.afternoonEnabled);
    await _settings.put(AppConstants.keyReminderEvening, s.reminder.eveningEnabled);
  }

  Future<void> putSetting(String key, dynamic value) async {
    await _settings.put(key, value);
  }

  T getSetting<T>(String key, {required T defaultValue}) {
    final value = _settings.get(key);
    if (value == null) return defaultValue;
    return value as T;
  }

  String? getStringOrNull(String key) {
    return _settings.get(key) as String?;
  }

  // ─── Mantras ────────────────────────────────────────────

  List<MantraModel> getAllMantras() {
    return _mantras.values
        .map((e) => MantraModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  MantraModel? getMantra(String id) {
    final raw = _mantras.get(id);
    if (raw == null) return null;
    return MantraModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  Future<void> saveMantra(MantraModel mantra) async {
    await _mantras.put(mantra.id, mantra.toMap());
  }

  Future<void> deleteMantra(String id) async {
    await _mantras.delete(id);
  }

  Future<MantraModel> addCustomMantra({
    required String name,
    required String text,
    String transliteration = '',
    String deityId = 'swaminarayan',
    int target = 108,
  }) async {
    final mantra = MantraModel(
      id: 'custom_${_uuid.v4()}',
      name: name,
      text: text,
      transliteration: transliteration.isEmpty ? name : transliteration,
      deityId: deityId,
      target: target,
      isCustom: true,
    );
    await saveMantra(mantra);
    return mantra;
  }

  // ─── Daily Progress ─────────────────────────────────────

  // ─── Daily Progress (mantra-wise) ───────────────────────

  DailyProgressModel getDailyProgress(String dateKey, {required String mantraId}) {
    final key = DailyProgressModel.keyFor(dateKey, mantraId);
    final raw = _dailyProgress.get(key);
    if (raw == null) {
      // Legacy fallback: plain date key without mantra
      final legacy = _dailyProgress.get(dateKey);
      if (legacy != null) {
        final model = DailyProgressModel.fromMap(Map<dynamic, dynamic>.from(legacy as Map));
        if (model.mantraId.isEmpty || model.mantraId == mantraId) {
          return model.copyWith(mantraId: mantraId, dateKey: dateKey);
        }
      }
      final target =
          _settings.get(AppConstants.keyDailyTarget, defaultValue: AppConstants.defaultDailyTarget)
              as int;
      return DailyProgressModel(dateKey: dateKey, mantraId: mantraId, target: target);
    }
    return DailyProgressModel.fromMap(Map<dynamic, dynamic>.from(raw as Map))
        .copyWith(dateKey: dateKey, mantraId: mantraId);
  }

  DailyProgressModel getTodayProgress({required String mantraId}) =>
      getDailyProgress(DateHelper.todayKey(), mantraId: mantraId);

  /// Sum of all mantra jap for a calendar day (analytics / streak).
  DailyProgressModel getDayAggregate(String dateKey) {
    final parts = <DailyProgressModel>[];
    for (final key in _dailyProgress.keys) {
      final k = key.toString();
      if (k == dateKey || k.startsWith('$dateKey|')) {
        parts.add(DailyProgressModel.fromMap(
          Map<dynamic, dynamic>.from(_dailyProgress.get(key) as Map),
        ));
      }
    }
    if (parts.isEmpty) {
      final target =
          _settings.get(AppConstants.keyDailyTarget, defaultValue: AppConstants.defaultDailyTarget)
              as int;
      return DailyProgressModel(dateKey: dateKey, target: target);
    }
    return DailyProgressModel.aggregate(dateKey, parts);
  }

  Future<void> saveDailyProgress(DailyProgressModel progress) async {
    final model = progress.mantraId.isEmpty
        ? progress
        : progress.copyWith(mantraId: progress.mantraId);
    await _dailyProgress.put(model.storageKey, model.toMap());
  }

  List<DailyProgressModel> getProgressRange(List<String> keys) {
    return keys.map(getDayAggregate).toList();
  }

  List<DailyProgressModel> getAllProgress() {
    // Aggregate by date for analytics
    final byDate = <String, List<DailyProgressModel>>{};
    for (final e in _dailyProgress.values) {
      final m = DailyProgressModel.fromMap(Map<dynamic, dynamic>.from(e as Map));
      byDate.putIfAbsent(m.dateKey, () => []).add(m);
    }
    return byDate.entries
        .map((e) => DailyProgressModel.aggregate(e.key, e.value))
        .toList()
      ..sort((a, b) => a.dateKey.compareTo(b.dateKey));
  }

  int getBeadPositionForMantra(String mantraId) {
    return getSetting<int>(AppConstants.beadKeyForMantra(mantraId), defaultValue: 0);
  }

  Future<void> setBeadPositionForMantra(String mantraId, int bead) async {
    await putSetting(AppConstants.beadKeyForMantra(mantraId), bead);
  }

  /// Atomically increment today's count for a specific mantra.
  Future<JapIncrementResult> incrementJap({
    required String mantraId,
    int amount = 1,
  }) async {
    final today = DateHelper.todayKey();
    final now = DateTime.now();
    var progress = getDailyProgress(today, mantraId: mantraId);
    final previousCount = progress.totalCount;
    final newCount = previousCount + amount;

    // Bead / mala — per mantra
    var bead = getBeadPositionForMantra(mantraId);
    var malaIncrement = 0;
    bead += amount;
    while (bead >= AppConstants.malaBeads) {
      bead -= AppConstants.malaBeads;
      malaIncrement++;
    }
    await setBeadPositionForMantra(mantraId, bead);

    final justCompletedTarget = !progress.targetCompleted &&
        progress.target > 0 &&
        newCount >= progress.target;

    progress = progress.copyWith(
      mantraId: mantraId,
      totalCount: newCount,
      malaCount: progress.malaCount + malaIncrement,
      firstSessionAt: progress.firstSessionAt ?? now,
      lastSessionAt: now,
      targetCompleted: progress.targetCompleted || justCompletedTarget,
    );
    await saveDailyProgress(progress);

    // Mantra lifetime total
    final mantra = getMantra(mantraId);
    if (mantra != null) {
      await saveMantra(mantra.copyWith(totalCount: mantra.totalCount + amount));
    }

    // App lifetime
    final lifetime =
        getSetting<int>(AppConstants.keyLifetimeCount, defaultValue: 0) + amount;
    await putSetting(AppConstants.keyLifetimeCount, lifetime);
    if (malaIncrement > 0) {
      final lm = getSetting<int>(AppConstants.keyLifetimeMala, defaultValue: 0) + malaIncrement;
      await putSetting(AppConstants.keyLifetimeMala, lm);
    }

    // Streak based on any jap today
    await _updateStreakOnJap(today);

    // Active session count bump
    final sessionId = getStringOrNull(AppConstants.keyActiveSessionId);
    if (sessionId != null) {
      final raw = _sessions.get(sessionId);
      if (raw != null) {
        final session =
            JapSessionModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
        await _sessions.put(
          sessionId,
          session.copyWith(count: session.count + amount).toMap(),
        );
      }
    }

    return JapIncrementResult(
      progress: progress,
      beadPosition: bead,
      malaJustCompleted: malaIncrement > 0,
      malaIncrement: malaIncrement,
      targetJustCompleted: justCompletedTarget,
      previousCount: previousCount,
    );
  }

  Future<void> _updateStreakOnJap(String todayKey) async {
    final lastActive =
        getStringOrNull(AppConstants.keyLastActiveDate);
    var current = getSetting<int>(AppConstants.keyCurrentStreak, defaultValue: 0);
    var longest = getSetting<int>(AppConstants.keyLongestStreak, defaultValue: 0);

    if (lastActive == todayKey) {
      // Already counted today
      return;
    }

    if (lastActive == null) {
      current = 1;
    } else {
      final gap = DateHelper.daysBetween(lastActive, todayKey);
      if (gap == 1) {
        current += 1;
      } else if (gap > 1) {
        current = 1;
      }
    }

    if (current > longest) longest = current;

    await putSetting(AppConstants.keyLastActiveDate, todayKey);
    await putSetting(AppConstants.keyCurrentStreak, current);
    await putSetting(AppConstants.keyLongestStreak, longest);
  }

  int getCurrentStreak() {
    final lastActive =
        getStringOrNull(AppConstants.keyLastActiveDate);
    final current = getSetting<int>(AppConstants.keyCurrentStreak, defaultValue: 0);
    if (lastActive == null) return 0;
    final today = DateHelper.todayKey();
    final yesterday = DateHelper.yesterdayKey();
    if (lastActive == today || lastActive == yesterday) return current;
    return 0;
  }

  int getLongestStreak() =>
      getSetting<int>(AppConstants.keyLongestStreak, defaultValue: 0);

  int getBeadPosition([String? mantraId]) {
    final id = mantraId ??
        (_settings.get(AppConstants.keySelectedMantra, defaultValue: 'mantra_swaminarayan') as String);
    return getBeadPositionForMantra(id);
  }

  // ─── Sessions ───────────────────────────────────────────

  Future<JapSessionModel> startSession(
    String mantraId, {
    String mode = JapMode.normal,
    int target = 108,
  }) async {
    // End any dangling session
    await endActiveSession();

    final session = JapSessionModel(
      id: _uuid.v4(),
      mantraId: mantraId,
      startedAt: DateTime.now(),
      mode: mode,
      target: target,
    );
    await _sessions.put(session.id, session.toMap());
    await putSetting(AppConstants.keyActiveSessionId, session.id);

    final today = getTodayProgress(mantraId: mantraId);
    await saveDailyProgress(today.copyWith(
      mantraId: mantraId,
      sessionCount: today.sessionCount + 1,
      firstSessionAt: today.firstSessionAt ?? session.startedAt,
    ));
    final ls = getSetting<int>(AppConstants.keyLifetimeSessions, defaultValue: 0) + 1;
    await putSetting(AppConstants.keyLifetimeSessions, ls);

    return session;
  }

  Future<JapSessionModel?> endActiveSession() async {
    final sessionId = getStringOrNull(AppConstants.keyActiveSessionId);
    if (sessionId == null) return null;
    final raw = _sessions.get(sessionId);
    if (raw == null) {
      await _settings.delete(AppConstants.keyActiveSessionId);
      return null;
    }
    final session = JapSessionModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
    final ended = DateTime.now();
    final duration = ended.difference(session.startedAt).inSeconds;
    final updated = session.copyWith(endedAt: ended, durationSeconds: duration);
    await _sessions.put(session.id, updated.toMap());
    await _settings.delete(AppConstants.keyActiveSessionId);

    final today = getTodayProgress(mantraId: session.mantraId);
    await saveDailyProgress(
      today.copyWith(
        mantraId: session.mantraId,
        totalDurationSeconds: today.totalDurationSeconds + duration,
        lastSessionAt: ended,
      ),
    );
    final ld =
        getSetting<int>(AppConstants.keyLifetimeDuration, defaultValue: 0) + duration;
    await putSetting(AppConstants.keyLifetimeDuration, ld);

    return updated;
  }

  JapSessionModel? getActiveSession() {
    final sessionId = getStringOrNull(AppConstants.keyActiveSessionId);
    if (sessionId == null) return null;
    final raw = _sessions.get(sessionId);
    if (raw == null) return null;
    return JapSessionModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  List<JapSessionModel> getAllSessions() {
    return _sessions.values
        .map((e) => JapSessionModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  List<JapSessionModel> getSessionsForDate(String dateKey) {
    return getAllSessions().where((s) => DateHelper.dateKey(s.startedAt) == dateKey).toList();
  }

  // ─── Favorites ──────────────────────────────────────────

  List<FavoriteModel> getFavorites({String? type}) {
    final all = _favorites.values
        .map((e) => FavoriteModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
    if (type == null) return all;
    return all.where((f) => f.type == type).toList();
  }

  Future<void> toggleFavorite({required String type, required String itemId}) async {
    final existing = getFavorites(type: type).where((f) => f.itemId == itemId);
    if (existing.isNotEmpty) {
      await _favorites.delete(existing.first.id);
      if (type == 'mantra') {
        final m = getMantra(itemId);
        if (m != null) await saveMantra(m.copyWith(isFavorite: false));
      }
    } else {
      final fav = FavoriteModel(id: _uuid.v4(), type: type, itemId: itemId);
      await _favorites.put(fav.id, fav.toMap());
      if (type == 'mantra') {
        final m = getMantra(itemId);
        if (m != null) await saveMantra(m.copyWith(isFavorite: true));
      }
    }
  }

  bool isFavorite({required String type, required String itemId}) {
    return getFavorites(type: type).any((f) => f.itemId == itemId);
  }

  // ─── Reset ──────────────────────────────────────────────

  Future<void> resetToday() async {
    final today = DateHelper.todayKey();
    final target =
        _settings.get(AppConstants.keyDailyTarget, defaultValue: AppConstants.defaultDailyTarget)
            as int;
    final keysToDelete = _dailyProgress.keys
        .map((k) => k.toString())
        .where((k) => k == today || k.startsWith('$today|'))
        .toList();
    for (final k in keysToDelete) {
      await _dailyProgress.delete(k);
    }
    // Reset beads for all mantras
    for (final m in getAllMantras()) {
      await setBeadPositionForMantra(m.id, 0);
    }
    await putSetting(AppConstants.keyBeadPosition, 0);
    await endActiveSession();
    // Keep empty selected mantra record with current target
    final selected =
        _settings.get(AppConstants.keySelectedMantra, defaultValue: 'mantra_swaminarayan') as String;
    await saveDailyProgress(
      DailyProgressModel(dateKey: today, mantraId: selected, target: target),
    );
  }

  Future<void> resetAllData() async {
    await endActiveSession();
    await _dailyProgress.clear();
    await _sessions.clear();
    await _favorites.clear();
    await _mantras.clear();
    await _settings.clear();
    await _meta.clear();
    await _meta.put(AppConstants.keyDbVersion, AppConstants.databaseVersion);
    await _seedIfNeeded();
  }

  // ─── Backup ─────────────────────────────────────────────

  Map<String, dynamic> exportJson() {
    return {
      'version': AppConstants.databaseVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': Map<String, dynamic>.from(_settings.toMap()),
      'mantras': _mantras.toMap().map((k, v) => MapEntry(k.toString(), v)),
      'dailyProgress': _dailyProgress.toMap().map((k, v) => MapEntry(k.toString(), v)),
      'sessions': _sessions.toMap().map((k, v) => MapEntry(k.toString(), v)),
      'favorites': _favorites.toMap().map((k, v) => MapEntry(k.toString(), v)),
      'meta': Map<String, dynamic>.from(_meta.toMap()),
    };
  }

  Future<void> importJson(Map<String, dynamic> data) async {
    final version = data['version'] as int? ?? 1;
    if (version > AppConstants.databaseVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    await endActiveSession();

    if (data['settings'] is Map) {
      final settings = Map<String, dynamic>.from(data['settings'] as Map);
      for (final e in settings.entries) {
        await _settings.put(e.key, e.value);
      }
    }
    if (data['mantras'] is Map) {
      await _mantras.clear();
      final mantras = Map<String, dynamic>.from(data['mantras'] as Map);
      for (final e in mantras.entries) {
        await _mantras.put(e.key, e.value);
      }
    }
    if (data['dailyProgress'] is Map) {
      await _dailyProgress.clear();
      final progress = Map<String, dynamic>.from(data['dailyProgress'] as Map);
      for (final e in progress.entries) {
        await _dailyProgress.put(e.key, e.value);
      }
    }
    if (data['sessions'] is Map) {
      await _sessions.clear();
      final sessions = Map<String, dynamic>.from(data['sessions'] as Map);
      for (final e in sessions.entries) {
        await _sessions.put(e.key, e.value);
      }
    }
    if (data['favorites'] is Map) {
      await _favorites.clear();
      final favorites = Map<String, dynamic>.from(data['favorites'] as Map);
      for (final e in favorites.entries) {
        await _favorites.put(e.key, e.value);
      }
    }
  }

  String exportJsonString() => const JsonEncoder.withIndent('  ').convert(exportJson());

  Future<void> importJsonString(String jsonStr) async {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup file');
    }
    await importJson(decoded);
  }
}

class JapIncrementResult {
  JapIncrementResult({
    required this.progress,
    required this.beadPosition,
    required this.malaJustCompleted,
    required this.malaIncrement,
    required this.targetJustCompleted,
    required this.previousCount,
  });

  final DailyProgressModel progress;
  final int beadPosition;
  final bool malaJustCompleted;
  final int malaIncrement;
  final bool targetJustCompleted;
  final int previousCount;
}
