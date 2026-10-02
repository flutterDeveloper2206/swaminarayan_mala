import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Swaminarayan Maala'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Jai Swaminarayan — Har Saans Mein Naam, Har Pal Mein Shanti.'**
  String get appSlogan;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @jap.
  ///
  /// In en, this message translates to:
  /// **'Jap'**
  String get jap;

  /// No description provided for @mala.
  ///
  /// In en, this message translates to:
  /// **'Mala'**
  String get mala;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Sadhana'**
  String get progress;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @mantras.
  ///
  /// In en, this message translates to:
  /// **'Mantras'**
  String get mantras;

  /// No description provided for @startJap.
  ///
  /// In en, this message translates to:
  /// **'Start Jap'**
  String get startJap;

  /// No description provided for @continueJap.
  ///
  /// In en, this message translates to:
  /// **'Continue Jap'**
  String get continueJap;

  /// No description provided for @todayJap.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Jap'**
  String get todayJap;

  /// No description provided for @dailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTarget;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @totalJap.
  ///
  /// In en, this message translates to:
  /// **'Total Jap'**
  String get totalJap;

  /// No description provided for @totalMala.
  ///
  /// In en, this message translates to:
  /// **'Total Mala'**
  String get totalMala;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// No description provided for @selectMantra.
  ///
  /// In en, this message translates to:
  /// **'Select Mantra'**
  String get selectMantra;

  /// No description provided for @selectDeity.
  ///
  /// In en, this message translates to:
  /// **'Select Guru / Murti'**
  String get selectDeity;

  /// No description provided for @addMantra.
  ///
  /// In en, this message translates to:
  /// **'Add Mantra'**
  String get addMantra;

  /// No description provided for @editMantra.
  ///
  /// In en, this message translates to:
  /// **'Edit Mantra'**
  String get editMantra;

  /// No description provided for @deleteMantra.
  ///
  /// In en, this message translates to:
  /// **'Delete Mantra'**
  String get deleteMantra;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @exitFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Exit Focus Mode'**
  String get exitFocusMode;

  /// No description provided for @nightMode.
  ///
  /// In en, this message translates to:
  /// **'Night Jap'**
  String get nightMode;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Tap sound'**
  String get sound;

  /// No description provided for @backgroundMusic.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get backgroundMusic;

  /// No description provided for @musicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music volume'**
  String get musicVolume;

  /// No description provided for @musicSection.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get musicSection;

  /// No description provided for @ambientTrack.
  ///
  /// In en, this message translates to:
  /// **'Music track'**
  String get ambientTrack;

  /// No description provided for @defaultAmbientTrack.
  ///
  /// In en, this message translates to:
  /// **'Swaminarayan Divine Dhun'**
  String get defaultAmbientTrack;

  /// No description provided for @chooseAmbientFile.
  ///
  /// In en, this message translates to:
  /// **'Choose from files'**
  String get chooseAmbientFile;

  /// No description provided for @useDefaultAmbient.
  ///
  /// In en, this message translates to:
  /// **'Use default'**
  String get useDefaultAmbient;

  /// No description provided for @ambientResetDone.
  ///
  /// In en, this message translates to:
  /// **'Using default mandir music'**
  String get ambientResetDone;

  /// No description provided for @ambientImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Music imported'**
  String get ambientImportSuccess;

  /// No description provided for @ambientImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import music'**
  String get ambientImportFailed;

  /// No description provided for @ambientPlaybackMode.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get ambientPlaybackMode;

  /// No description provided for @ambientPlaybackModeHint.
  ///
  /// In en, this message translates to:
  /// **'Loop forever, play once, or continue only while the app is open'**
  String get ambientPlaybackModeHint;

  /// No description provided for @ambientModeLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get ambientModeLoop;

  /// No description provided for @ambientModeOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get ambientModeOnce;

  /// No description provided for @ambientModeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ambientModeContinue;

  /// No description provided for @haptic.
  ///
  /// In en, this message translates to:
  /// **'Haptic'**
  String get haptic;

  /// No description provided for @volumeButtonJap.
  ///
  /// In en, this message translates to:
  /// **'Volume Button Jap'**
  String get volumeButtonJap;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @enableReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable Reminder'**
  String get enableReminder;

  /// No description provided for @disableReminder.
  ///
  /// In en, this message translates to:
  /// **'Disable Reminder'**
  String get disableReminder;

  /// No description provided for @yourSadhana.
  ///
  /// In en, this message translates to:
  /// **'Your Sadhana'**
  String get yourSadhana;

  /// No description provided for @dailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// No description provided for @weeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @yearlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Yearly Progress'**
  String get yearlyProgress;

  /// No description provided for @lifetimeStats.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetimeStats;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @targetCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sankalp is complete'**
  String get targetCompleted;

  /// No description provided for @malaCompleted.
  ///
  /// In en, this message translates to:
  /// **'One mala complete'**
  String get malaCompleted;

  /// No description provided for @startAgain.
  ///
  /// In en, this message translates to:
  /// **'Start Again'**
  String get startAgain;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get keepGoing;

  /// No description provided for @noJapToday.
  ///
  /// In en, this message translates to:
  /// **'No jap yet today'**
  String get noJapToday;

  /// No description provided for @startYourFirstJap.
  ///
  /// In en, this message translates to:
  /// **'Begin with your first Naam today'**
  String get startYourFirstJap;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @resetToday.
  ///
  /// In en, this message translates to:
  /// **'Reset Today\'s Progress'**
  String get resetToday;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @japSettings.
  ///
  /// In en, this message translates to:
  /// **'Jap Settings'**
  String get japSettings;

  /// No description provided for @dataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSection;

  /// No description provided for @privacyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Jap data stays on your device.'**
  String get privacyMessage;

  /// No description provided for @quickMantras.
  ///
  /// In en, this message translates to:
  /// **'Quick Mantras'**
  String get quickMantras;

  /// No description provided for @mantraLibrary.
  ///
  /// In en, this message translates to:
  /// **'Mantra Library'**
  String get mantraLibrary;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @mantraName.
  ///
  /// In en, this message translates to:
  /// **'Mantra Name'**
  String get mantraName;

  /// No description provided for @mantraText.
  ///
  /// In en, this message translates to:
  /// **'Mantra Text'**
  String get mantraText;

  /// No description provided for @optionalDeity.
  ///
  /// In en, this message translates to:
  /// **'Deity'**
  String get optionalDeity;

  /// No description provided for @customTarget.
  ///
  /// In en, this message translates to:
  /// **'Custom Target'**
  String get customTarget;

  /// No description provided for @todaysMala.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Mala'**
  String get todaysMala;

  /// No description provided for @todaysSessions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sessions'**
  String get todaysSessions;

  /// No description provided for @tapToJap.
  ///
  /// In en, this message translates to:
  /// **'JAP'**
  String get tapToJap;

  /// No description provided for @tapHint.
  ///
  /// In en, this message translates to:
  /// **'TAP'**
  String get tapHint;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Jai Swaminarayan'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Begin each day with Swaminarayan Naam Jap and inner peace.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Jap, Mala & Namavali'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'108 beads, daily targets, and a Sahajanand Namavali remembrance path.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Your Sadhana'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Streaks, insights, and progress — all offline on your device.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Focus'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Select a guru or murti presence for your digital mandir.'**
  String get onboardingDesc4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Start Jap'**
  String get getStarted;

  /// No description provided for @sadhanaAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Sadhana Analytics'**
  String get sadhanaAnalytics;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get activeDays;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @preferredTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred Time'**
  String get preferredTime;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @noStoriesYet.
  ///
  /// In en, this message translates to:
  /// **'Stories will soon become part of your sadhana.'**
  String get noStoriesYet;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'Save mantras and stories you love here.'**
  String get noFavoritesYet;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @resetTodayConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will clear today\'s jap count. Continue?'**
  String get resetTodayConfirm;

  /// No description provided for @resetAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all jap data. This cannot be undone.'**
  String get resetAllConfirm;

  /// No description provided for @resetAllConfirm2.
  ///
  /// In en, this message translates to:
  /// **'Type confirm again — all sadhana history will be erased.'**
  String get resetAllConfirm2;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup ready to share.'**
  String get exportSuccess;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully.'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file.'**
  String get importFailed;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled. You can enable them from device settings.'**
  String get notificationPermissionDenied;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time for Swaminarayan Naam Jap — Jai Swaminarayan.'**
  String get reminderBody;

  /// No description provided for @reminderTargetBody.
  ///
  /// In en, this message translates to:
  /// **'A little more Naam will complete today\'s target.'**
  String get reminderTargetBody;

  /// No description provided for @autoStartLastMantra.
  ///
  /// In en, this message translates to:
  /// **'Auto-start last mantra'**
  String get autoStartLastMantra;

  /// No description provided for @categoryRam.
  ///
  /// In en, this message translates to:
  /// **'Ram'**
  String get categoryRam;

  /// No description provided for @categoryKrishna.
  ///
  /// In en, this message translates to:
  /// **'Krishna'**
  String get categoryKrishna;

  /// No description provided for @categoryShiva.
  ///
  /// In en, this message translates to:
  /// **'Shiva'**
  String get categoryShiva;

  /// No description provided for @categoryHanuman.
  ///
  /// In en, this message translates to:
  /// **'Hanuman'**
  String get categoryHanuman;

  /// No description provided for @categoryDevi.
  ///
  /// In en, this message translates to:
  /// **'Devi'**
  String get categoryDevi;

  /// No description provided for @categoryGanesh.
  ///
  /// In en, this message translates to:
  /// **'Ganesh'**
  String get categoryGanesh;

  /// No description provided for @categoryVishnu.
  ///
  /// In en, this message translates to:
  /// **'Vishnu'**
  String get categoryVishnu;

  /// No description provided for @categoryCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get categoryCustom;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @streakMilestone.
  ///
  /// In en, this message translates to:
  /// **'Your sadhana reached a milestone'**
  String get streakMilestone;

  /// No description provided for @aajKiSadhana.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sadhana'**
  String get aajKiSadhana;

  /// No description provided for @kalPhirSe.
  ///
  /// In en, this message translates to:
  /// **'Begin again tomorrow with the same peace.'**
  String get kalPhirSe;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @dbError.
  ///
  /// In en, this message translates to:
  /// **'Could not open local storage. Please restart the app.'**
  String get dbError;

  /// No description provided for @naamCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Naam'**
  String naamCount(int count);

  /// No description provided for @malaCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} mala complete'**
  String malaCompletedCount(int count);

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} Day Streak'**
  String daysStreak(int count);

  /// No description provided for @remainingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String remainingCount(int count);

  /// No description provided for @minutesDuration.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesDuration(int count);

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(int hours, int minutes);

  /// No description provided for @targetProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String targetProgress(int current, int target);

  /// No description provided for @sessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{duration} · {count} Naam'**
  String sessionSummary(String duration, int count);

  /// No description provided for @insightMonthly.
  ///
  /// In en, this message translates to:
  /// **'You have completed {count} Naam this month.'**
  String insightMonthly(int count);

  /// No description provided for @insightConsistency.
  ///
  /// In en, this message translates to:
  /// **'You practiced on {days} of the last {total} days.'**
  String insightConsistency(int days, int total);

  /// No description provided for @insightBestDay.
  ///
  /// In en, this message translates to:
  /// **'Your highest Jap was {count} Naam.'**
  String insightBestDay(int count);

  /// No description provided for @streakMilestoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Your sadhana has completed {days} days.'**
  String streakMilestoneMessage(int days);

  /// No description provided for @dailyQuoteFallback.
  ///
  /// In en, this message translates to:
  /// **'Where there is Naam, there is peace.'**
  String get dailyQuoteFallback;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePicture;

  /// No description provided for @kidsJap.
  ///
  /// In en, this message translates to:
  /// **'Kids Jap'**
  String get kidsJap;

  /// No description provided for @kidsJapShort.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get kidsJapShort;

  /// No description provided for @kidsJapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Naam Jap through play.'**
  String get kidsJapSubtitle;

  /// No description provided for @kidsJapIntro.
  ///
  /// In en, this message translates to:
  /// **'Tap falling flowers and stars — each tap is one Naam.'**
  String get kidsJapIntro;

  /// No description provided for @kidsJapCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make Naam Jap fun for little devotees'**
  String get kidsJapCardSubtitle;

  /// No description provided for @startKidsJap.
  ///
  /// In en, this message translates to:
  /// **'Start Kids Jap'**
  String get startKidsJap;

  /// No description provided for @chooseTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose Target'**
  String get chooseTarget;

  /// No description provided for @plusOneJap.
  ///
  /// In en, this message translates to:
  /// **'+1 Jap'**
  String get plusOneJap;

  /// No description provided for @kidsWonderful.
  ///
  /// In en, this message translates to:
  /// **'Wonderful! 🌸'**
  String get kidsWonderful;

  /// No description provided for @kidsShabash.
  ///
  /// In en, this message translates to:
  /// **'Shabash! 🙏'**
  String get kidsShabash;

  /// No description provided for @kidsJapCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Wonderful!'**
  String get kidsJapCompletedTitle;

  /// No description provided for @kidsJapCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You completed {count} Jap.'**
  String kidsJapCompletedBody(int count);

  /// No description provided for @pauseJap.
  ///
  /// In en, this message translates to:
  /// **'Jap Pause'**
  String get pauseJap;

  /// No description provided for @kidsPauseMessage.
  ///
  /// In en, this message translates to:
  /// **'Take a soft breath. Resume when ready.'**
  String get kidsPauseMessage;

  /// No description provided for @resumeJap.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeJap;

  /// No description provided for @restartJap.
  ///
  /// In en, this message translates to:
  /// **'Jap again'**
  String get restartJap;

  /// No description provided for @exitJap.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitJap;

  /// No description provided for @normalJap.
  ///
  /// In en, this message translates to:
  /// **'Normal Jap'**
  String get normalJap;

  /// No description provided for @kidsJapCount.
  ///
  /// In en, this message translates to:
  /// **'Kids Jap'**
  String get kidsJapCount;

  /// No description provided for @reminderMode.
  ///
  /// In en, this message translates to:
  /// **'Reminder Mode'**
  String get reminderMode;

  /// No description provided for @reminderModeAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask Me'**
  String get reminderModeAsk;

  /// No description provided for @kidsPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get kidsPlayAgain;

  /// No description provided for @kidsGoToJap.
  ///
  /// In en, this message translates to:
  /// **'Go to Jap'**
  String get kidsGoToJap;

  /// No description provided for @kidsKeepGoingLittle.
  ///
  /// In en, this message translates to:
  /// **'Keep going, little devotee! 🙏'**
  String get kidsKeepGoingLittle;

  /// No description provided for @japCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Jap Count'**
  String get japCountLabel;

  /// No description provided for @kidsTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the falling blessings'**
  String get kidsTapHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
