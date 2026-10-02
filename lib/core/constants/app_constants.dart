class AppConstants {
  AppConstants._();

  static const String appName = 'Swaminarayan Maala';
  static const String appSlogan =
      'Jai Swaminarayan  Har Saans Mein Naam, Har Pal Mein Shanti.';
  static const int databaseVersion = 1;
  static const int malaBeads = 108;
  static const int defaultDailyTarget = 108;
  static const List<int> presetTargets = [108, 216, 500, 1008, 5000, 10000];
  static const List<int> streakMilestones = [3, 7, 21, 40, 108, 365];

  // Hive box names
  static const String boxSettings = 'settings';
  static const String boxMantras = 'mantras';
  static const String boxDailyProgress = 'daily_progress';
  static const String boxSessions = 'sessions';
  static const String boxFavorites = 'favorites';
  static const String boxMeta = 'meta';

  // Settings keys
  static const String keyDbVersion = 'db_version';
  static const String keyFirstLaunch = 'first_launch_completed';
  static const String keySelectedDeity = 'selected_deity_id';
  static const String keySelectedMantra = 'selected_mantra_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyHapticEnabled = 'haptic_enabled';
  static const String keyVolumeButton = 'volume_button_enabled';
  static const String keyDailyTarget = 'daily_target';
  static const String keyLanguage = 'language_code';
  static const String keyUserName = 'user_name';
  static const String keyProfileImage = 'profile_image_path';
  static const String keyNightMode = 'night_mode';
  static const String keyFocusMode = 'focus_mode';
  static const String keyAutoStart = 'auto_start_last_mantra';
  static const String keyReminderEnabled = 'reminder_enabled';
  static const String keyReminderHour = 'reminder_hour';
  static const String keyReminderMinute = 'reminder_minute';
  static const String keyReminderMorning = 'reminder_morning';
  static const String keyReminderAfternoon = 'reminder_afternoon';
  static const String keyReminderEvening = 'reminder_evening';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyLongestStreak = 'longest_streak';
  static const String keyLastActiveDate = 'last_active_date';
  static const String keyLifetimeCount = 'lifetime_count';
  static const String keyLifetimeMala = 'lifetime_mala';
  static const String keyLifetimeSessions = 'lifetime_sessions';
  static const String keyLifetimeDuration = 'lifetime_duration_seconds';
  static const String keyBeadPosition = 'bead_position';
  static const String keyActiveSessionId = 'active_session_id';
  static const String keyBackgroundMusic = 'background_music_enabled';
  static const String keyBackgroundMusicVolume = 'background_music_volume';
  static const String keyAmbientMusicPath = 'ambient_music_path';
  static const String keyAmbientPlaybackMode = 'ambient_playback_mode';
  static const String keyReminderMode = 'reminder_mode';

  /// Ambient playback: loop | once | continue
  static const String ambientModeLoop = 'loop';
  static const String ambientModeOnce = 'once';
  static const String ambientModeContinue = 'continue';

  static String beadKeyForMantra(String mantraId) => 'bead_position_$mantraId';

  static const List<int> kidsTargets = [11, 21, 51, 108, 216];
  static const int defaultKidsTarget = 108;

  static const int defaultReminderHour = 7;
  static const int defaultReminderMinute = 0;

  static const String defaultFocusId = 'swaminarayan';
  static const String defaultMantraId = 'mantra_swaminarayan';
}
