import 'package:flutter/material.dart';

import '../features/favorites/favorites_screen.dart';
import '../features/jap/jap_screen.dart';
import '../features/kids/kids_jap_entry_screen.dart';
import '../features/mala/mala_screen.dart';
import '../features/mantras/mantra_list_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/settings/appearance_settings_screen.dart';
import '../features/settings/data_settings_screen.dart';
import '../features/settings/deity_settings_screen.dart';
import '../features/settings/jap_settings_screen.dart';
import '../features/settings/language_settings_screen.dart';
import '../features/settings/music_settings_screen.dart';
import '../features/settings/reminder_settings_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/splash/splash_screen.dart';
import '../features/stories/stories_screen.dart';
import '../features/stories/story_detail_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const jap = '/jap';
  static const mantras = '/mantras';
  static const mantrasAdd = '/mantras/add';
  static const mantrasDetail = '/mantras/detail';
  static const mala = '/mala';
  static const progress = '/progress';
  static const stories = '/stories';
  static const storiesDetail = '/stories/detail';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const settingsJap = '/settings/jap';
  static const settingsMusic = '/settings/music';
  static const settingsDeity = '/settings/deity';
  static const settingsReminder = '/settings/reminder';
  static const settingsAppearance = '/settings/appearance';
  static const settingsLanguage = '/settings/language';
  static const settingsData = '/settings/data';
  static const profile = '/profile';
  static const deitySelect = '/deity';
  static const kidsJap = '/kids-jap';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _fade(const SplashScreen(), routeSettings);
      case onboarding:
        return _fade(const OnboardingScreen(), routeSettings);
      case home:
        return _fade(const MainShell(), routeSettings);
      case jap:
        final mantraId = routeSettings.arguments as String?;
        return _slide(JapScreen(mantraId: mantraId), routeSettings);
      case mantras:
        return _slide(const MantraListScreen(), routeSettings);
      case mantrasAdd:
        return _slide(const AddMantraScreen(), routeSettings);
      case mantrasDetail:
        final id = routeSettings.arguments as String? ?? '';
        return _slide(MantraDetailScreen(mantraId: id), routeSettings);
      case mala:
        return _slide(const MalaScreen(), routeSettings);
      case progress:
        return _slide(const ProgressScreen(), routeSettings);
      case stories:
        return _slide(const StoriesScreen(), routeSettings);
      case storiesDetail:
        final id = routeSettings.arguments as String? ?? '';
        return _slide(StoryDetailScreen(storyId: id), routeSettings);
      case favorites:
        return _slide(const FavoritesScreen(), routeSettings);
      case kidsJap:
        return _slide(const KidsJapEntryScreen(), routeSettings);
      case settings:
        return _slide(const SettingsScreen(), routeSettings);
      case settingsJap:
        return _slide(const JapSettingsScreen(), routeSettings);
      case settingsMusic:
        return _slide(const MusicSettingsScreen(), routeSettings);
      case settingsDeity:
      case deitySelect:
        return _slide(const DeitySettingsScreen(), routeSettings);
      case settingsReminder:
        return _slide(const ReminderSettingsScreen(), routeSettings);
      case settingsAppearance:
        return _slide(const AppearanceSettingsScreen(), routeSettings);
      case settingsLanguage:
        return _slide(const LanguageSettingsScreen(), routeSettings);
      case settingsData:
        return _slide(const DataSettingsScreen(), routeSettings);
      case profile:
        return _slide(const ProfileScreen(), routeSettings);
      default:
        return _fade(const SplashScreen(), routeSettings);
    }
  }

  static PageRouteBuilder _fade(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _slide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final offset = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(position: offset, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
    );
  }
}
