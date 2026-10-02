class AssetConstants {
  AssetConstants._();

  static const String images = 'assets/images';
  static const String gods = 'assets/gods';
  static const String gurus = 'assets/gurus';
  static const String backgrounds = 'assets/backgrounds';
  static const String icons = 'assets/icons';
  static const String audio = 'assets/audio';
  static const String stories = 'assets/stories';
  static const String data = 'assets/data';

  static const String storiesJson = 'assets/data/stories.json';
  static const String quotesJson = 'assets/data/quotes.json';
  static const String namavaliLabelsJson = 'assets/data/namavali_labels.json';

  static const String tapSound = 'assets/audio/tap.mp3';
  static const String malaCompleteSound = 'assets/audio/mala_complete.mp3';
  static const String targetCompleteSound = 'assets/audio/target_complete.mp3';
  /// Bundled default ambient (Swaminarayan Divine Dhun).
  static const String defaultAmbientMusic = 'assets/audio/default_ambient.mp3';
  static const String ambientMusic = defaultAmbientMusic;

  static String deityImage(String deityId) => '$gurus/$deityId.webp';

  static String languageBadge(String code) => '$images/lang_$code.png';

  static const String kidsBg = 'assets/kids/mandir_kids_bg.png';
  static const String kidsCatch = 'assets/kids/kids_catch.png';
  static const String kidsWin = 'assets/kids/kids_win.png';
  static const String rudrakshaBead = 'assets/images/rudraksha_bead.png';
}
