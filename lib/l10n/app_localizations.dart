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
  /// **'Reset Application Data'**
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
