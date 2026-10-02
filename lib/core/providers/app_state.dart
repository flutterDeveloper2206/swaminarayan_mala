import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/jap_session_model.dart';
import '../../data/local/local_database.dart';
import '../../data/models/daily_progress_model.dart';
import '../../data/models/mantra_model.dart';
import '../../data/models/settings_model.dart';
import '../../data/models/story_model.dart';
import '../constants/app_constants.dart';
import '../constants/asset_constants.dart';
import '../helpers/date_helper.dart';
import '../helpers/haptic_helper.dart';
import '../helpers/locale_helper.dart';
import '../services/audio_service.dart';
import '../services/namavali_service.dart';
import '../services/reminder_service.dart';

/// Central app state — settings, mantras, today's progress, stories.
class AppState extends ChangeNotifier {
  final _db = LocalDatabase.instance;

  SettingsModel _settings = SettingsModel(languageCode: LocaleHelper.systemLanguageCode());
  List<MantraModel> _mantras = [];
  DailyProgressModel _today = DailyProgressModel(dateKey: DateHelper.todayKey());
  List<StoryModel> _stories = [];
  List<Map<String, String>> _quotes = [];
  int _beadPosition = 0;
  bool _ready = false;
  String? _error;

  // Celebration flags (UI consumes then clears)
  bool malaJustCompleted = false;
  bool targetJustCompleted = false;
  int? streakMilestoneReached;

  SettingsModel get settings => _settings;
  List<MantraModel> get mantras => List.unmodifiable(_mantras);
  DailyProgressModel get today => _today;
  List<StoryModel> get stories => List.unmodifiable(_stories);
  int get beadPosition => _beadPosition;
  bool get ready => _ready;
  String? get error => _error;
  bool get isHindi => _settings.languageCode == 'hi';
  bool get isGujarati => _settings.languageCode == 'gu';

  MantraModel? get selectedMantra => _db.getMantra(_settings.selectedMantraId);

  bool get isNamavaliPath =>
      NamavaliService.isNamavaliMantra(_settings.selectedMantraId);

  /// Current Namavali remembrance label for the active bead (1–108).
  String? get currentNamavaliLabel {
    if (!isNamavaliPath) return null;
    final label = NamavaliService.instance.labelForBead(_beadPosition);
    return label?.forLanguage(_settings.languageCode);
  }

  String get dailyQuote {
    if (_quotes.isEmpty) {
      if (isHindi) return 'जहाँ नाम है, वहाँ शांति है।';
      if (isGujarati) return 'જ્યાં નામ છે, ત્યાં શાંતિ છે.';
      return 'Where there is Naam, there is peace.';
    }
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final q = _quotes[dayOfYear % _quotes.length];
    if (isHindi) return q['hi'] ?? q['en'] ?? '';
    if (isGujarati) return q['gu'] ?? q['en'] ?? q['hi'] ?? '';
    return q['en'] ?? q['hi'] ?? '';
  }

  Future<void> init() async {
    try {
      await _db.init();
      _settings = _db.getSettings();
      _mantras = _db.getAllMantras();
      _loadTodayForSelectedMantra();
      await _loadStories();
      await _loadQuotes();
      await NamavaliService.instance.load();
      await _syncAmbientMusic();
      _ready = true;
      _error = null;
      notifyListeners();
    } catch (e, st) {
      debugPrint('AppState.init: $e\n$st');
      _error = e.toString();
      _ready = false;
      notifyListeners();
    }
  }

  void _loadTodayForSelectedMantra() {
    final id = _settings.selectedMantraId;
    _today = _db.getTodayProgress(mantraId: id);
    if (_today.totalCount == 0 && _today.target != _settings.dailyTarget) {
      _today = _today.copyWith(target: _settings.dailyTarget, mantraId: id);
      _db.saveDailyProgress(_today);
    }
    _beadPosition = _db.getBeadPositionForMantra(id);
  }

  Future<void> _syncAmbientMusic({bool forceRestart = false}) async {
    await AudioService.instance.startAmbient(
      enabled: _settings.backgroundMusicEnabled,
      volume: _settings.backgroundMusicVolume,
      customPath: _settings.ambientMusicPath,
      mode: _settings.ambientPlaybackMode,
      forceRestart: forceRestart,
    );
  }

  /// Copy picked audio into app documents and set as custom ambient.
  Future<bool> importAmbientMusic(String sourcePath, {String? originalName}) async {
    try {
      final src = File(sourcePath);
      if (!await src.exists()) return false;
      final ext = _audioExtension(originalName ?? sourcePath);
      final docs = await _ambientDir();
      final safeName = _safeFileName(originalName ?? 'custom_ambient.$ext', ext);
      final dest = File('${docs.path}/$safeName');
      // Clear previous custom files in ambient/
      await for (final entity in docs.list()) {
        if (entity is File) {
          try {
            await entity.delete();
          } catch (_) {}
        }
      }
      await src.copy(dest.path);
      _settings = _settings.copyWith(ambientMusicPath: dest.path);
      await _db.saveSettings(_settings);
      await _syncAmbientMusic(forceRestart: true);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('importAmbientMusic: $e');
      return false;
    }
  }

  Future<void> resetAmbientMusicToDefault() async {
    final path = _settings.ambientMusicPath.trim();
    if (path.isNotEmpty) {
      try {
        final f = File(path);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
    try {
      final dir = await _ambientDir();
      await for (final entity in dir.list()) {
        if (entity is File) {
          try {
            await entity.delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
    _settings = _settings.copyWith(ambientMusicPath: '');
    await _db.saveSettings(_settings);
    await _syncAmbientMusic(forceRestart: true);
    notifyListeners();
  }

  Future<void> setAmbientPlaybackMode(String mode) async {
    final normalized = switch (mode) {
      AppConstants.ambientModeOnce ||
      AppConstants.ambientModeContinue =>
        mode,
      _ => AppConstants.ambientModeLoop,
    };
    if (normalized == _settings.ambientPlaybackMode) return;
    _settings = _settings.copyWith(ambientPlaybackMode: normalized);
    await _db.saveSettings(_settings);
    await _syncAmbientMusic(forceRestart: true);
    notifyListeners();
  }

  Future<Directory> _ambientDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/ambient');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  String _audioExtension(String name) {
    final lower = name.toLowerCase();
    for (final e in ['mp3', 'm4a', 'wav', 'aac']) {
      if (lower.endsWith('.$e')) return e;
    }
    return 'mp3';
  }

  String _safeFileName(String name, String ext) {
    var base = name.split(Platform.pathSeparator).last.trim();
    if (base.isEmpty) base = 'custom_ambient.$ext';
    base = base.replaceAll(RegExp(r'[^\w.\- ()\[\]]+'), '_');
    if (!base.toLowerCase().endsWith('.$ext')) {
      base = '$base.$ext';
    }
    if (base.length > 80) {
      final stem = base.substring(0, base.length - ext.length - 1);
      base = '${stem.substring(0, 60)}.$ext';
    }
    return base;
  }

  /// Today's count for any mantra (home quick cards).
  int todayCountForMantra(String mantraId) {
    return _db.getTodayProgress(mantraId: mantraId).totalCount;
  }

  DailyProgressModel todayForMantra(String mantraId) {
    return _db.getTodayProgress(mantraId: mantraId);
  }

  Future<void> _loadStories() async {
    try {
      final raw = await rootBundle.loadString(AssetConstants.storiesJson);
      final list = jsonDecode(raw) as List<dynamic>;
      final favIds = _db.getFavorites(type: 'story').map((f) => f.itemId).toSet();
      _stories = list
          .map((e) => StoryModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .map((s) => s.copyWith(isFavorite: favIds.contains(s.id)))
          .toList();
    } catch (e) {
      debugPrint('Load stories: $e');
      _stories = [];
    }
  }

  Future<void> _loadQuotes() async {
    try {
      final raw = await rootBundle.loadString(AssetConstants.quotesJson);
      final list = jsonDecode(raw) as List<dynamic>;
      _quotes = list.map((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return {
          'en': m['en']?.toString() ?? '',
          'hi': m['hi']?.toString() ?? '',
          'gu': m['gu']?.toString() ?? '',
        };
      }).toList();
    } catch (_) {
      _quotes = [];
    }
  }

  Future<void> refresh() async {
    _settings = _db.getSettings();
    _mantras = _db.getAllMantras();
    _loadTodayForSelectedMantra();
    notifyListeners();
  }

  Future<void> completeOnboarding({String? deityId, String? mantraId}) async {
    _settings = _settings.copyWith(
      firstLaunchCompleted: true,
      selectedDeityId: deityId ?? _settings.selectedDeityId,
      selectedMantraId: mantraId ?? _settings.selectedMantraId,
    );
    await _db.saveSettings(_settings);
    _loadTodayForSelectedMantra();
    notifyListeners();
  }

  Future<void> updateSettings(SettingsModel next) async {
    final reminderChanged = next.reminder.enabled != _settings.reminder.enabled ||
        next.reminder.hour != _settings.reminder.hour ||
        next.reminder.minute != _settings.reminder.minute ||
        next.reminder.morningEnabled != _settings.reminder.morningEnabled ||
        next.reminder.afternoonEnabled != _settings.reminder.afternoonEnabled ||
        next.reminder.eveningEnabled != _settings.reminder.eveningEnabled;

    final musicChanged = next.backgroundMusicEnabled != _settings.backgroundMusicEnabled ||
        next.backgroundMusicVolume != _settings.backgroundMusicVolume ||
        next.ambientMusicPath != _settings.ambientMusicPath ||
        next.ambientPlaybackMode != _settings.ambientPlaybackMode;

    // If target changed and today hasn't completed, update selected mantra's today target
    if (next.dailyTarget != _settings.dailyTarget && !_today.targetCompleted) {
      _today = _today.copyWith(
        target: next.dailyTarget,
        mantraId: _settings.selectedMantraId,
      );
      await _db.saveDailyProgress(_today);
    }

    final forceMusicRestart = next.ambientMusicPath != _settings.ambientMusicPath ||
        next.ambientPlaybackMode != _settings.ambientPlaybackMode;

    _settings = next;
    await _db.saveSettings(_settings);

    if (reminderChanged) {
      await ReminderService.instance.syncFromSettings(_settings);
    }
    if (musicChanged) {
      await _syncAmbientMusic(forceRestart: forceMusicRestart);
    }
    notifyListeners();
  }

  Future<void> selectDeity(String deityId) async {
    _settings = _settings.copyWith(selectedDeityId: deityId);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> selectMantra(String mantraId) async {
    _settings = _settings.copyWith(selectedMantraId: mantraId);
    await _db.saveSettings(_settings);
    _loadTodayForSelectedMantra();
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _settings = _settings.copyWith(languageCode: code);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _settings = _settings.copyWith(userName: name.trim());
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setProfileImagePath(String path) async {
    _settings = _settings.copyWith(profileImagePath: path);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> clearProfileImage() async {
    final old = _settings.profileImagePath;
    _settings = _settings.copyWith(profileImagePath: '');
    await _db.saveSettings(_settings);
    if (old.isNotEmpty) {
      try {
        final file = File(old);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setNightMode(bool value) async {
    _settings = _settings.copyWith(nightMode: value);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setFocusMode(bool value) async {
    _settings = _settings.copyWith(focusMode: value);
    await _db.saveSettings(_settings);
    notifyListeners();
  }

  /// Core jap tap — persists immediately.
  Future<JapIncrementResult> japTap({String? mantraId}) async {
    final id = mantraId ?? _settings.selectedMantraId;
    final result = await _db.incrementJap(mantraId: id);
    if (id == _settings.selectedMantraId) {
      _today = result.progress;
      _beadPosition = result.beadPosition;
    }
    malaJustCompleted = result.malaJustCompleted;
    targetJustCompleted = result.targetJustCompleted;

    // Streak milestone
    final streak = _db.getCurrentStreak();
    if (AppConstants.streakMilestones.contains(streak) &&
        _db.getSetting(AppConstants.keyLastActiveDate, defaultValue: '') ==
            DateHelper.todayKey()) {
      // Only fire once when day first becomes active and streak hits milestone
      final flagKey = 'milestone_$streak';
      if (!_db.getSetting(flagKey, defaultValue: false)) {
        streakMilestoneReached = streak;
        await _db.putSetting(flagKey, true);
      }
    }

    await HapticHelper.light(enabled: _settings.hapticEnabled);
    if (result.malaJustCompleted) {
      await HapticHelper.medium(enabled: _settings.hapticEnabled);
      await AudioService.instance.playMalaComplete(enabled: _settings.soundEnabled);
    } else if (result.targetJustCompleted) {
      await HapticHelper.heavy(enabled: _settings.hapticEnabled);
      await AudioService.instance.playTargetComplete(enabled: _settings.soundEnabled);
    } else {
      await AudioService.instance.playTap(enabled: _settings.soundEnabled);
    }

    // Refresh mantra list counts lightly
    _mantras = _db.getAllMantras();
    notifyListeners();
    return result;
  }

  void clearCelebrations() {
    malaJustCompleted = false;
    targetJustCompleted = false;
    streakMilestoneReached = null;
  }

  Future<void> startSession({
    String? mantraId,
    String mode = JapMode.normal,
    int? target,
  }) async {
    final id = mantraId ?? _settings.selectedMantraId;
    await _db.startSession(
      id,
      mode: mode,
      target: target ?? _settings.dailyTarget,
    );
    _today = _db.getTodayProgress(mantraId: id);
    _beadPosition = _db.getBeadPositionForMantra(id);
    notifyListeners();
  }

  JapSessionModel? get activeSession => _db.getActiveSession();

  /// Today's jap count from kids-mode sessions only.
  int kidsJapCountToday() {
    final today = DateHelper.todayKey();
    return _db
        .getAllSessions()
        .where((s) => s.isKids && DateHelper.dateKey(s.startedAt) == today)
        .fold<int>(0, (sum, s) => sum + s.count);
  }

  Future<void> endSession() async {
    await _db.endActiveSession();
    _loadTodayForSelectedMantra();
    notifyListeners();
  }

  Future<void> toggleMantraFavorite(String mantraId) async {
    await _db.toggleFavorite(type: 'mantra', itemId: mantraId);
    _mantras = _db.getAllMantras();
    notifyListeners();
  }

  Future<void> toggleStoryFavorite(String storyId) async {
    await _db.toggleFavorite(type: 'story', itemId: storyId);
    final favIds = _db.getFavorites(type: 'story').map((f) => f.itemId).toSet();
    _stories = _stories.map((s) => s.copyWith(isFavorite: favIds.contains(s.id))).toList();
    notifyListeners();
  }

  Future<MantraModel> addMantra({
    required String name,
    required String text,
    String transliteration = '',
    String deityId = 'swaminarayan',
    int target = 108,
  }) async {
    final m = await _db.addCustomMantra(
      name: name,
      text: text,
      transliteration: transliteration,
      deityId: deityId,
      target: target,
    );
    _mantras = _db.getAllMantras();
    notifyListeners();
    return m;
  }

  Future<void> deleteMantra(String id) async {
    await _db.deleteMantra(id);
    if (_settings.selectedMantraId == id) {
      _settings = _settings.copyWith(selectedMantraId: AppConstants.defaultMantraId);
      await _db.saveSettings(_settings);
    }
    _mantras = _db.getAllMantras();
    notifyListeners();
  }

  Future<void> resetToday() async {
    await _db.resetToday();
    await refresh();
  }

  Future<void> resetAll() async {
    await _db.resetAllData();
    await init();
  }

  String exportBackup() => _db.exportJsonString();

  Future<void> importBackup(String json) async {
    await _db.importJsonString(json);
    await init();
  }

  int get currentStreak => _db.getCurrentStreak();
  int get longestStreak => _db.getLongestStreak();
}
