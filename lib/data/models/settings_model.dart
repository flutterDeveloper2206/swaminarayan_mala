class ReminderSettingsModel {
  ReminderSettingsModel({
    this.enabled = false,
    this.hour = 7,
    this.minute = 0,
    this.morningEnabled = false,
    this.afternoonEnabled = false,
    this.eveningEnabled = false,
  });

  final bool enabled;
  final int hour;
  final int minute;
  final bool morningEnabled;
  final bool afternoonEnabled;
  final bool eveningEnabled;

  ReminderSettingsModel copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    bool? morningEnabled,
    bool? afternoonEnabled,
    bool? eveningEnabled,
  }) {
    return ReminderSettingsModel(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      morningEnabled: morningEnabled ?? this.morningEnabled,
      afternoonEnabled: afternoonEnabled ?? this.afternoonEnabled,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
    );
  }

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
        'hour': hour,
        'minute': minute,
        'morningEnabled': morningEnabled,
        'afternoonEnabled': afternoonEnabled,
        'eveningEnabled': eveningEnabled,
      };

  factory ReminderSettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return ReminderSettingsModel(
      enabled: map['enabled'] as bool? ?? false,
      hour: map['hour'] as int? ?? 7,
      minute: map['minute'] as int? ?? 0,
      morningEnabled: map['morningEnabled'] as bool? ?? false,
      afternoonEnabled: map['afternoonEnabled'] as bool? ?? false,
      eveningEnabled: map['eveningEnabled'] as bool? ?? false,
    );
  }
}

class SettingsModel {
  SettingsModel({
    this.firstLaunchCompleted = false,
    this.selectedDeityId = 'swaminarayan',
    this.selectedMantraId = 'mantra_swaminarayan',
    this.themeMode = 'system',
    this.soundEnabled = false,
    this.backgroundMusicEnabled = true,
    this.backgroundMusicVolume = 0.35,
    this.ambientMusicPath = '',
    this.ambientPlaybackMode = 'loop',
    this.hapticEnabled = true,
    this.volumeButtonEnabled = false,
    this.dailyTarget = 108,
    this.languageCode = 'en',
    this.userName = '',
    this.profileImagePath = '',
    this.nightMode = false,
    this.focusMode = false,
    this.autoStartLastMantra = true,
    this.reminderMode = 'normal',
    ReminderSettingsModel? reminder,
  }) : reminder = reminder ?? ReminderSettingsModel();

  final bool firstLaunchCompleted;
  final String selectedDeityId;
  final String selectedMantraId;
  final String themeMode;
  final bool soundEnabled;
  final bool backgroundMusicEnabled;
  final double backgroundMusicVolume;
  /// Empty = bundled default ambient asset.
  final String ambientMusicPath;
  /// loop | once | continue
  final String ambientPlaybackMode;
  final bool hapticEnabled;
  final bool volumeButtonEnabled;
  final int dailyTarget;
  final String languageCode;
  final String userName;
  final String profileImagePath;
  final bool nightMode;
  final bool focusMode;
  final bool autoStartLastMantra;
  /// Reminder opens: normal | kids | ask
  final String reminderMode;
  final ReminderSettingsModel reminder;

  bool get isHindi => languageCode == 'hi';
  bool get isGujarati => languageCode == 'gu';
  bool get hasCustomAmbient => ambientMusicPath.trim().isNotEmpty;

  SettingsModel copyWith({
    bool? firstLaunchCompleted,
    String? selectedDeityId,
    String? selectedMantraId,
    String? themeMode,
    bool? soundEnabled,
    bool? backgroundMusicEnabled,
    double? backgroundMusicVolume,
    String? ambientMusicPath,
    String? ambientPlaybackMode,
    bool? hapticEnabled,
    bool? volumeButtonEnabled,
    int? dailyTarget,
    String? languageCode,
    String? userName,
    String? profileImagePath,
    bool? nightMode,
    bool? focusMode,
    bool? autoStartLastMantra,
    String? reminderMode,
    ReminderSettingsModel? reminder,
  }) {
    return SettingsModel(
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      selectedDeityId: selectedDeityId ?? this.selectedDeityId,
      selectedMantraId: selectedMantraId ?? this.selectedMantraId,
      themeMode: themeMode ?? this.themeMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      backgroundMusicEnabled: backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      backgroundMusicVolume: backgroundMusicVolume ?? this.backgroundMusicVolume,
      ambientMusicPath: ambientMusicPath ?? this.ambientMusicPath,
      ambientPlaybackMode: ambientPlaybackMode ?? this.ambientPlaybackMode,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      volumeButtonEnabled: volumeButtonEnabled ?? this.volumeButtonEnabled,
      dailyTarget: dailyTarget ?? this.dailyTarget,
      languageCode: languageCode ?? this.languageCode,
      userName: userName ?? this.userName,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      nightMode: nightMode ?? this.nightMode,
      focusMode: focusMode ?? this.focusMode,
      autoStartLastMantra: autoStartLastMantra ?? this.autoStartLastMantra,
      reminderMode: reminderMode ?? this.reminderMode,
      reminder: reminder ?? this.reminder,
    );
  }
}
