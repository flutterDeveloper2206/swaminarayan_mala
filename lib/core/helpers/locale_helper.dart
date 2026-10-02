import 'dart:ui' show PlatformDispatcher;

/// Resolves device system language to an app-supported code: en / hi / gu.
class LocaleHelper {
  LocaleHelper._();

  static const supported = {'en', 'hi', 'gu'};

  /// Primary system language, mapped to SwamiNaam locales.
  static String systemLanguageCode() {
    final locales = PlatformDispatcher.instance.locales;
    for (final locale in locales) {
      final code = locale.languageCode.toLowerCase();
      if (supported.contains(code)) return code;
    }
    final primary = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    if (supported.contains(primary)) return primary;
    return 'en';
  }
}
