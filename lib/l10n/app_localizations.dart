import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Planner'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @ibadahChecklist.
  ///
  /// In en, this message translates to:
  /// **'Ibadah Checklist'**
  String get ibadahChecklist;

  /// No description provided for @didYouFast.
  ///
  /// In en, this message translates to:
  /// **'Did you fast today?'**
  String get didYouFast;

  /// No description provided for @prayers.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get prayers;

  /// No description provided for @adhkar.
  ///
  /// In en, this message translates to:
  /// **'Adhkar'**
  String get adhkar;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Peshawar'**
  String get cityHint;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @detectMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Detect My Location'**
  String get detectMyLocation;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethod;

  /// No description provided for @calculationMethodKarachi.
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get calculationMethodKarachi;

  /// No description provided for @calculationMethodISNA.
  ///
  /// In en, this message translates to:
  /// **'Islamic Society of North America'**
  String get calculationMethodISNA;

  /// No description provided for @calculationMethodMWL.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get calculationMethodMWL;

  /// No description provided for @calculationMethodMakkah.
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura University, Makkah'**
  String get calculationMethodMakkah;

  /// No description provided for @calculationMethodEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority of Survey'**
  String get calculationMethodEgypt;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @schoolStandard.
  ///
  /// In en, this message translates to:
  /// **'Shafi\'i / Maliki / Hanbali'**
  String get schoolStandard;

  /// No description provided for @schoolHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get schoolHanafi;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @taraweeh.
  ///
  /// In en, this message translates to:
  /// **'Taraweeh'**
  String get taraweeh;

  /// No description provided for @quranTilawat.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an Tilawat'**
  String get quranTilawat;

  /// No description provided for @islamicStudy.
  ///
  /// In en, this message translates to:
  /// **'Islamic Study'**
  String get islamicStudy;

  /// No description provided for @morningEveningAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Morning/Evening Adhkar'**
  String get morningEveningAdhkar;

  /// No description provided for @surahMulk.
  ///
  /// In en, this message translates to:
  /// **'Surah Al-Mulk'**
  String get surahMulk;

  /// No description provided for @istighfar.
  ///
  /// In en, this message translates to:
  /// **'Istighfar'**
  String get istighfar;

  /// No description provided for @durood.
  ///
  /// In en, this message translates to:
  /// **'Durood'**
  String get durood;

  /// No description provided for @subhanAllah.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get subhanAllah;

  /// No description provided for @sadaqah.
  ///
  /// In en, this message translates to:
  /// **'Sadaqah'**
  String get sadaqah;

  /// No description provided for @addCustomItem.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Item'**
  String get addCustomItem;

  /// No description provided for @fard.
  ///
  /// In en, this message translates to:
  /// **'Fard'**
  String get fard;

  /// No description provided for @sunnah.
  ///
  /// In en, this message translates to:
  /// **'Sunnah'**
  String get sunnah;

  /// No description provided for @jamah.
  ///
  /// In en, this message translates to:
  /// **'Jamah'**
  String get jamah;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @daysFull.
  ///
  /// In en, this message translates to:
  /// **'Days Full'**
  String get daysFull;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

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

  /// No description provided for @valueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @ashra.
  ///
  /// In en, this message translates to:
  /// **'Ashra'**
  String get ashra;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Assalam O Alikum'**
  String get greeting;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get guestUser;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @hijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get hijri;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorDate.
  ///
  /// In en, this message translates to:
  /// **'Error loading date'**
  String get errorDate;

  /// No description provided for @saveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save Progress'**
  String get saveProgress;

  /// No description provided for @resetDay.
  ///
  /// In en, this message translates to:
  /// **'Reset Day?'**
  String get resetDay;

  /// No description provided for @resetDayContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset Day {day}? All progress for this day will be lost.'**
  String resetDayContent(Object day);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @tasbihName.
  ///
  /// In en, this message translates to:
  /// **'Tasbih Name'**
  String get tasbihName;

  /// No description provided for @tasbihNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SubhanAllah'**
  String get tasbihNameHint;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @eveningReflection.
  ///
  /// In en, this message translates to:
  /// **'Evening Reflection'**
  String get eveningReflection;

  /// No description provided for @reflectionBest.
  ///
  /// In en, this message translates to:
  /// **'Best Moment'**
  String get reflectionBest;

  /// No description provided for @reflectionShortfall.
  ///
  /// In en, this message translates to:
  /// **'What I fell short in'**
  String get reflectionShortfall;

  /// No description provided for @reflectionSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special dua I made'**
  String get reflectionSpecial;

  /// No description provided for @reflectionGratitude.
  ///
  /// In en, this message translates to:
  /// **'One thing I\'m grateful for'**
  String get reflectionGratitude;

  /// No description provided for @resetAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data?'**
  String get resetAllDataTitle;

  /// No description provided for @resetAllDataContent.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your trackers, duas, and settings. This action cannot be undone.'**
  String get resetAllDataContent;

  /// No description provided for @resetAppData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Progress'**
  String get resetAppData;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanent.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied.'**
  String get locationPermissionPermanent;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting location...'**
  String get detectingLocation;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Error detecting location: {error}'**
  String locationError(Object error);

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @allDataReset.
  ///
  /// In en, this message translates to:
  /// **'All data has been reset.'**
  String get allDataReset;

  /// No description provided for @dayTitle.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayTitle(Object day);

  /// No description provided for @ashra1.
  ///
  /// In en, this message translates to:
  /// **'1st Ashra (Mercy)'**
  String get ashra1;

  /// No description provided for @ashra2.
  ///
  /// In en, this message translates to:
  /// **'2nd Ashra (Forgiveness)'**
  String get ashra2;

  /// No description provided for @ashra3.
  ///
  /// In en, this message translates to:
  /// **'3rd Ashra (Freedom)'**
  String get ashra3;

  /// No description provided for @ashraTitle.
  ///
  /// In en, this message translates to:
  /// **'Ashra'**
  String get ashraTitle;

  /// No description provided for @ashra1Title.
  ///
  /// In en, this message translates to:
  /// **'1st Ashra'**
  String get ashra1Title;

  /// No description provided for @ashra1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Mercy'**
  String get ashra1Subtitle;

  /// No description provided for @ashra2Title.
  ///
  /// In en, this message translates to:
  /// **'2nd Ashra'**
  String get ashra2Title;

  /// No description provided for @ashra2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Forgiveness'**
  String get ashra2Subtitle;

  /// No description provided for @ashra3Title.
  ///
  /// In en, this message translates to:
  /// **'3rd Ashra'**
  String get ashra3Title;

  /// No description provided for @ashra3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Freedom'**
  String get ashra3Subtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'About Ramadan Planner\n\nRamadan Planner is a thoughtfully designed mobile application created to help Muslims organize, track, and enhance their spiritual journey during the holy month of Ramadan. The app provides essential tools such as prayer time notifications, Azan alarms, Quran reading features, tasbeeh counter, dua collection, and daily routine tracking to support users in maintaining consistency and focus.\n\nThis application was designed and developed under the supervision and leadership of Khalid bin Waheed, who served as the Lead of the project team. From concept planning and feature structuring to design direction and implementation oversight, the app was built under his direct guidance to ensure quality, usability, and spiritual value.\n\nThe vision behind Ramadan Planner is to combine technology with faith in a simple, user-friendly, and meaningful way making Ramadan more organized, productive, and spiritually rewarding for everyone.\n\nOur Mission\nTo provide a reliable, easy-to-use digital companion that supports Muslims in strengthening their faith and daily worship during Ramadan and beyond.'**
  String get appDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @emailAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailAddressOptional;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @ageOptional.
  ///
  /// In en, this message translates to:
  /// **'Age (Optional)'**
  String get ageOptional;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'25'**
  String get ageHint;

  /// No description provided for @locationAndPrayer.
  ///
  /// In en, this message translates to:
  /// **'Location & Prayer'**
  String get locationAndPrayer;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get cityName;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @hour12.
  ///
  /// In en, this message translates to:
  /// **'12 Hour'**
  String get hour12;

  /// No description provided for @hour24.
  ///
  /// In en, this message translates to:
  /// **'24 Hour'**
  String get hour24;

  /// No description provided for @autoDetectGps.
  ///
  /// In en, this message translates to:
  /// **'Auto-Detect GPS'**
  String get autoDetectGps;

  /// No description provided for @gpsUpdated.
  ///
  /// In en, this message translates to:
  /// **'GPS Updated'**
  String get gpsUpdated;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @enableAnimations.
  ///
  /// In en, this message translates to:
  /// **'Enable Animations'**
  String get enableAnimations;

  /// No description provided for @fontScale.
  ///
  /// In en, this message translates to:
  /// **'Font Scale: {scale}x'**
  String fontScale(Object scale);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @reminderPreferences.
  ///
  /// In en, this message translates to:
  /// **'Reminder Preferences'**
  String get reminderPreferences;

  /// No description provided for @reminderSuffix.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderSuffix;

  /// No description provided for @notificationStyle.
  ///
  /// In en, this message translates to:
  /// **'Notification Style'**
  String get notificationStyle;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// No description provided for @clearTasbeehHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear Tasbeeh History'**
  String get clearTasbeehHistory;

  /// No description provided for @exportProgressPdf.
  ///
  /// In en, this message translates to:
  /// **'Export Progress (PDF)'**
  String get exportProgressPdf;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @privacyPolicyTerms.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy • Terms of Service'**
  String get privacyPolicyTerms;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} Coming Soon in v2.0!'**
  String comingSoon(Object feature);

  /// No description provided for @notifQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran Reading'**
  String get notifQuran;

  /// No description provided for @notifSuhoor.
  ///
  /// In en, this message translates to:
  /// **'Suhoor Meal'**
  String get notifSuhoor;

  /// No description provided for @notifIftar.
  ///
  /// In en, this message translates to:
  /// **'Iftar Time'**
  String get notifIftar;

  /// No description provided for @notifTaraweeh.
  ///
  /// In en, this message translates to:
  /// **'Taraweeh Prayer'**
  String get notifTaraweeh;

  /// No description provided for @notifDua.
  ///
  /// In en, this message translates to:
  /// **'Daily Dua'**
  String get notifDua;

  /// No description provided for @notifQuote.
  ///
  /// In en, this message translates to:
  /// **'Inspirational Quote'**
  String get notifQuote;

  /// No description provided for @notifWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get notifWeekly;

  /// No description provided for @allProgressReset.
  ///
  /// In en, this message translates to:
  /// **'All progress reset'**
  String get allProgressReset;

  /// No description provided for @holyQuran.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get holyQuran;

  /// No description provided for @quranArabic.
  ///
  /// In en, this message translates to:
  /// **'القرآن الكريم'**
  String get quranArabic;

  /// No description provided for @juzCompleted.
  ///
  /// In en, this message translates to:
  /// **'You completed {completed}/{goal} Juz today'**
  String juzCompleted(Object completed, Object goal);

  /// No description provided for @juzAddedTooltip.
  ///
  /// In en, this message translates to:
  /// **'I completed a Juz'**
  String get juzAddedTooltip;

  /// No description provided for @searchSurah.
  ///
  /// In en, this message translates to:
  /// **'Search surah...'**
  String get searchSurah;

  /// No description provided for @allJuz.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allJuz;

  /// No description provided for @juzLabel.
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String juzLabel(Object number);

  /// No description provided for @translationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation: '**
  String get translationLabel;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal} Juz'**
  String goalLabel(Object goal);

  /// No description provided for @versesLabel.
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get versesLabel;

  /// No description provided for @listenRecitation.
  ///
  /// In en, this message translates to:
  /// **'Listen to Recitation'**
  String get listenRecitation;

  /// No description provided for @dailyQuranGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Quran Goal'**
  String get dailyQuranGoal;

  /// No description provided for @juzPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} Juz per day'**
  String juzPerDay(Object count);

  /// No description provided for @finishQuran30Days.
  ///
  /// In en, this message translates to:
  /// **'Finish Quran in 30 days'**
  String get finishQuran30Days;

  /// No description provided for @finishQuranDays.
  ///
  /// In en, this message translates to:
  /// **'Finish Quran in {days} days'**
  String finishQuranDays(Object days);

  /// No description provided for @tasbeehCounter.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh Counter'**
  String get tasbeehCounter;

  /// No description provided for @counterTab.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterTab;

  /// No description provided for @duaListTab.
  ///
  /// In en, this message translates to:
  /// **'Dua List'**
  String get duaListTab;

  /// No description provided for @dayStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} DAY STREAK'**
  String dayStreakLabel(Object count);

  /// No description provided for @targetLabel.
  ///
  /// In en, this message translates to:
  /// **'TARGET: {target}'**
  String targetLabel(Object target);

  /// No description provided for @resetCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Counter?'**
  String get resetCounterTitle;

  /// No description provided for @resetCounterContent.
  ///
  /// In en, this message translates to:
  /// **'This will save your progress to history and reset today\'s count.'**
  String get resetCounterContent;

  /// No description provided for @setTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Target'**
  String get setTargetTitle;

  /// No description provided for @dailyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoalLabel;

  /// No description provided for @standardNotificationStyle.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardNotificationStyle;

  /// No description provided for @spiritualNotificationStyle.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Quotes'**
  String get spiritualNotificationStyle;

  /// No description provided for @minimalNotificationStyle.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get minimalNotificationStyle;

  /// No description provided for @azanAlarm.
  ///
  /// In en, this message translates to:
  /// **'Azan Alarm'**
  String get azanAlarm;

  /// No description provided for @prayerTimeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer time notifications'**
  String get prayerTimeNotifications;

  /// No description provided for @prayerAlarms.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alarms'**
  String get prayerAlarms;

  /// No description provided for @azanSound.
  ///
  /// In en, this message translates to:
  /// **'Azan Sound'**
  String get azanSound;

  /// No description provided for @azanMakkah.
  ///
  /// In en, this message translates to:
  /// **'Azan Makkah'**
  String get azanMakkah;

  /// No description provided for @azanMadinah.
  ///
  /// In en, this message translates to:
  /// **'Azan Madinah'**
  String get azanMadinah;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get historyCleared;

  /// No description provided for @setPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set App Lock PIN'**
  String get setPinTitle;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit PIN'**
  String get enterPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatch;

  /// No description provided for @appLockEnabledToast.
  ///
  /// In en, this message translates to:
  /// **'App Lock Enabled'**
  String get appLockEnabledToast;

  /// No description provided for @appLockDisabledToast.
  ///
  /// In en, this message translates to:
  /// **'App Lock Disabled'**
  String get appLockDisabledToast;

  /// No description provided for @mealPlanner.
  ///
  /// In en, this message translates to:
  /// **'Meal Planner'**
  String get mealPlanner;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake Tracker'**
  String get waterIntake;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @addGlass.
  ///
  /// In en, this message translates to:
  /// **'Add Glass'**
  String get addGlass;

  /// No description provided for @waterGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily water goal reached!'**
  String get waterGoalReached;

  /// No description provided for @suhoor.
  ///
  /// In en, this message translates to:
  /// **'Suhoor (Pre-dawn meal)'**
  String get suhoor;

  /// No description provided for @iftar.
  ///
  /// In en, this message translates to:
  /// **'Iftar (Breaking fast)'**
  String get iftar;

  /// No description provided for @healthyTips.
  ///
  /// In en, this message translates to:
  /// **'Healthy Fasting Tips'**
  String get healthyTips;

  /// No description provided for @suhoorDate.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get suhoorDate;

  /// No description provided for @suhoorYogurt.
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
  String get suhoorYogurt;

  /// No description provided for @suhoorOats.
  ///
  /// In en, this message translates to:
  /// **'Oats/Porridge'**
  String get suhoorOats;

  /// No description provided for @suhoorWater.
  ///
  /// In en, this message translates to:
  /// **'Lots of Water'**
  String get suhoorWater;

  /// No description provided for @iftarDates.
  ///
  /// In en, this message translates to:
  /// **'Dates (Sunnah)'**
  String get iftarDates;

  /// No description provided for @iftarWater.
  ///
  /// In en, this message translates to:
  /// **'Water/Juice'**
  String get iftarWater;

  /// No description provided for @iftarFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit Salad'**
  String get iftarFruit;

  /// No description provided for @iftarLight.
  ///
  /// In en, this message translates to:
  /// **'Light Soup'**
  String get iftarLight;

  /// No description provided for @suhoorDates.
  ///
  /// In en, this message translates to:
  /// **'Dates (3–5)'**
  String get suhoorDates;

  /// No description provided for @suhoorWaterItem.
  ///
  /// In en, this message translates to:
  /// **'Water (large glass)'**
  String get suhoorWaterItem;

  /// No description provided for @suhoorEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs (boiled or scrambled)'**
  String get suhoorEggs;

  /// No description provided for @suhoorOatsItem.
  ///
  /// In en, this message translates to:
  /// **'Oatmeal with honey'**
  String get suhoorOatsItem;

  /// No description provided for @suhoorBread.
  ///
  /// In en, this message translates to:
  /// **'Whole wheat bread'**
  String get suhoorBread;

  /// No description provided for @suhoorYogurtItem.
  ///
  /// In en, this message translates to:
  /// **'Yogurt / Lassi'**
  String get suhoorYogurtItem;

  /// No description provided for @suhoorFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits (banana, apple)'**
  String get suhoorFruits;

  /// No description provided for @suhoorNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts (almonds, walnuts)'**
  String get suhoorNuts;

  /// No description provided for @iftarBreakDates.
  ///
  /// In en, this message translates to:
  /// **'Break fast with dates'**
  String get iftarBreakDates;

  /// No description provided for @iftarWaterItem.
  ///
  /// In en, this message translates to:
  /// **'Water (2+ glasses)'**
  String get iftarWaterItem;

  /// No description provided for @iftarFruitSalad.
  ///
  /// In en, this message translates to:
  /// **'Fruit salad'**
  String get iftarFruitSalad;

  /// No description provided for @iftarShorba.
  ///
  /// In en, this message translates to:
  /// **'Shorba (soup)'**
  String get iftarShorba;

  /// No description provided for @iftarProtein.
  ///
  /// In en, this message translates to:
  /// **'Light protein'**
  String get iftarProtein;

  /// No description provided for @iftarSalad.
  ///
  /// In en, this message translates to:
  /// **'Salad / veggies'**
  String get iftarSalad;

  /// No description provided for @iftarRiceBread.
  ///
  /// In en, this message translates to:
  /// **'Rice or bread (moderate)'**
  String get iftarRiceBread;

  /// No description provided for @iftarAvoidFried.
  ///
  /// In en, this message translates to:
  /// **'Avoid fried foods'**
  String get iftarAvoidFried;

  /// No description provided for @tipWater.
  ///
  /// In en, this message translates to:
  /// **'Drink 8 glasses of water between Iftar and Suhoor'**
  String get tipWater;

  /// No description provided for @tipAvoidSalty.
  ///
  /// In en, this message translates to:
  /// **'Avoid salty, spicy, and fried foods – they increase thirst'**
  String get tipAvoidSalty;

  /// No description provided for @tipLateSuhoor.
  ///
  /// In en, this message translates to:
  /// **'Eat suhoor as late as possible before Fajr'**
  String get tipLateSuhoor;

  /// No description provided for @tipSlowIftar.
  ///
  /// In en, this message translates to:
  /// **'Don\'t overeat at Iftar - eat slowly and mindfully'**
  String get tipSlowIftar;

  /// No description provided for @tipExercise.
  ///
  /// In en, this message translates to:
  /// **'Light exercise after Taraweeh is great for digestion'**
  String get tipExercise;

  /// No description provided for @tipSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep 6–8 hours – rest is part of ibadah'**
  String get tipSleep;

  /// No description provided for @tipNoCaffeine.
  ///
  /// In en, this message translates to:
  /// **'Avoid caffeinated drinks that cause dehydration'**
  String get tipNoCaffeine;

  /// No description provided for @tipHealthyFood.
  ///
  /// In en, this message translates to:
  /// **'Prioritize fruits, vegetables, and complex carbs'**
  String get tipHealthyFood;

  /// No description provided for @verses.
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get verses;

  /// No description provided for @loadingAyahs.
  ///
  /// In en, this message translates to:
  /// **'Loading ayahs...'**
  String get loadingAyahs;

  /// No description provided for @failedLoadInternet.
  ///
  /// In en, this message translates to:
  /// **'Failed to load. Check internet.'**
  String get failedLoadInternet;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternet;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get addBookmark;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get shareApp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceContent.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions\n\nLast Updated: February 22, 2026\nApp Name: Ramadan Planner\n\n1. Acceptance of Terms\nBy accessing or using the Ramadan Planner mobile application (“App”), you agree to comply with these Terms & Conditions. If you do not agree, please discontinue use of the App.\n\n2. Use of the App\nThe App provides prayer times, Azan notifications, Quran features, tasbeeh counter, dua collection, and Ramadan tracking tools for personal and spiritual use only. You agree to use the App lawfully and responsibly.\n\n3. User Responsibility\nUsers are responsible for: Providing accurate information, Maintaining account security, Verifying prayer times with local authorities when necessary. The App does not replace religious scholars or official mosque announcements.\n\n4. Location & Accuracy\nPrayer times are calculated based on selected location and chosen calculation methods. Minor variations may occur. We are not liable for inaccuracies caused by device, GPS, or technical limitations.\n\n5. Intellectual Property\nAll content, design, branding, and features within the App are the property of Ramadan Planner and may not be copied, modified, or distributed without permission.\n\n6. Limitation of Liability\nThe App is provided “as is” without warranties. We are not responsible for missed notifications, device malfunctions, data loss, or service interruptions.\n\n7. Privacy\nUse of the App is also governed by our Privacy Policy.\n\n8. Modifications\nWe reserve the right to update these Terms or modify the App at any time. Continued use of the App constitutes acceptance of any changes.\n\n9. Governing Law\nThese Terms shall be governed by the laws of Pakistan.\n\n10. Contact\nFor inquiries, please contact:\nemail : codecrypticalitinnovators@gmail.com\nwebsite : codecraftpk.com'**
  String get termsOfServiceContent;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy. We only use your name and location to help you get correct prayer times and track your Ramadan goals. We never sell your data. You can delete your data anytime.'**
  String get privacyPolicyContent;

  /// No description provided for @ramadanGoals.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Goals'**
  String get ramadanGoals;

  /// No description provided for @totalGoals.
  ///
  /// In en, this message translates to:
  /// **'Total Goals'**
  String get totalGoals;

  /// No description provided for @goalsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalsCompleted;

  /// No description provided for @goalsInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get goalsInProgress;

  /// No description provided for @addCustomGoal.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Goal'**
  String get addCustomGoal;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal title'**
  String get goalTitle;

  /// No description provided for @goalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Read 100 pages'**
  String get goalHint;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get goalProgress;

  /// No description provided for @goalCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Goal Completed! Alhamdulillah!'**
  String get goalCompletedMsg;

  /// No description provided for @goalQuran.
  ///
  /// In en, this message translates to:
  /// **'Finish the Holy Quran'**
  String get goalQuran;

  /// No description provided for @goalPrayers.
  ///
  /// In en, this message translates to:
  /// **'Pray 5 times daily'**
  String get goalPrayers;

  /// No description provided for @goalSadaqah.
  ///
  /// In en, this message translates to:
  /// **'Give charity (sadaqah)'**
  String get goalSadaqah;

  /// No description provided for @goalDua.
  ///
  /// In en, this message translates to:
  /// **'Learn 10 special duas'**
  String get goalDua;

  /// No description provided for @goalFast.
  ///
  /// In en, this message translates to:
  /// **'Fast all 30 days'**
  String get goalFast;

  /// No description provided for @goalTaraweeh.
  ///
  /// In en, this message translates to:
  /// **'Pray Taraweeh'**
  String get goalTaraweeh;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;
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
      <String>['ar', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
