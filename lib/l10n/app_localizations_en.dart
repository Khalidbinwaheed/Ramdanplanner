// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ramadan Planner';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get ibadahChecklist => 'Ibadah Checklist';

  @override
  String get didYouFast => 'Did you fast today?';

  @override
  String get prayers => 'Prayers';

  @override
  String get city => 'City';

  @override
  String get cityHint => 'e.g. Peshawar';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get detectMyLocation => 'Detect My Location';

  @override
  String get calculationMethod => 'Calculation Method';

  @override
  String get calculationMethodKarachi =>
      'University of Islamic Sciences, Karachi';

  @override
  String get calculationMethodISNA => 'Islamic Society of North America';

  @override
  String get calculationMethodMWL => 'Muslim World League';

  @override
  String get calculationMethodMakkah => 'Umm Al-Qura University, Makkah';

  @override
  String get calculationMethodEgypt => 'Egyptian General Authority of Survey';

  @override
  String get school => 'School';

  @override
  String get schoolStandard => 'Shafi\'i / Maliki / Hanbali';

  @override
  String get schoolHanafi => 'Hanafi';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get currency => 'Currency';

  @override
  String get taraweeh => 'Taraweeh';

  @override
  String get quranTilawat => 'Qur\'an Tilawat';

  @override
  String get islamicStudy => 'Islamic Study';

  @override
  String get morningEveningAdhkar => 'Morning/Evening Adhkar';

  @override
  String get surahMulk => 'Surah Al-Mulk';

  @override
  String get istighfar => 'Istighfar';

  @override
  String get durood => 'Durood';

  @override
  String get subhanAllah => 'SubhanAllah';

  @override
  String get sadaqah => 'Sadaqah';

  @override
  String get addCustomItem => 'Add Custom Item';

  @override
  String get fard => 'Fard';

  @override
  String get sunnah => 'Sunnah';

  @override
  String get jamah => 'Jamah';

  @override
  String get streak => 'Streak';

  @override
  String get daysFull => 'Days Full';

  @override
  String get update => 'Update';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get valueLabel => 'Value';

  @override
  String get day => 'Day';

  @override
  String get ashra => 'Ashra';

  @override
  String get overall => 'Overall';

  @override
  String get greeting => 'Assalam O Alikum';

  @override
  String get guestUser => 'User';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter your name';

  @override
  String get hijri => 'Hijri';

  @override
  String get loading => 'Loading...';

  @override
  String get errorDate => 'Error loading date';

  @override
  String get saveProgress => 'Save Progress';

  @override
  String get resetDay => 'Reset Day?';

  @override
  String resetDayContent(Object day) {
    return 'Are you sure you want to reset Day $day? All progress for this day will be lost.';
  }

  @override
  String get reset => 'Reset';

  @override
  String get tasbihName => 'Tasbih Name';

  @override
  String get tasbihNameHint => 'e.g. SubhanAllah';

  @override
  String get edit => 'Edit';

  @override
  String get eveningReflection => 'Evening Reflection';

  @override
  String get reflectionBest => 'Best Moment';

  @override
  String get reflectionShortfall => 'What I fell short in';

  @override
  String get reflectionSpecial => 'Special dua I made';

  @override
  String get reflectionGratitude => 'One thing I\'m grateful for';

  @override
  String get resetAllDataTitle => 'Reset All Data?';

  @override
  String get resetAllDataContent =>
      'This will delete all your trackers, duas, and settings. This action cannot be undone.';

  @override
  String get resetAppData => 'Reset Application Data';

  @override
  String get locationDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permissions are denied';

  @override
  String get locationPermissionPermanent =>
      'Location permissions are permanently denied.';

  @override
  String get detectingLocation => 'Detecting location...';

  @override
  String locationError(Object error) {
    return 'Error detecting location: $error';
  }

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get allDataReset => 'All data has been reset.';

  @override
  String dayTitle(Object day) {
    return 'Day $day';
  }

  @override
  String get ashra1 => '1st Ashra (Mercy)';

  @override
  String get ashra2 => '2nd Ashra (Forgiveness)';

  @override
  String get ashra3 => '3rd Ashra (Freedom)';

  @override
  String get ashraTitle => 'Ashra';

  @override
  String get ashra1Title => '1st Ashra';

  @override
  String get ashra1Subtitle => 'Mercy';

  @override
  String get ashra2Title => '2nd Ashra';

  @override
  String get ashra2Subtitle => 'Forgiveness';

  @override
  String get ashra3Title => '3rd Ashra';

  @override
  String get ashra3Subtitle => 'Freedom';
}
