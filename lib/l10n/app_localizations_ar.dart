// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مخطط رمضان';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get prayerTimes => 'أوقات الصلاة';

  @override
  String get fajr => 'الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get ibadahChecklist => 'قائمة العبادات';

  @override
  String get didYouFast => 'هل صمت اليوم؟';

  @override
  String get prayers => 'الصلوات';

  @override
  String get city => 'المدينة';

  @override
  String get cityHint => 'مثال: مكة المكرمة';

  @override
  String get latitude => 'خط العرض';

  @override
  String get longitude => 'خط الطول';

  @override
  String get detectMyLocation => 'تحديد موقعي';

  @override
  String get calculationMethod => 'طريقة الحساب';

  @override
  String get calculationMethodKarachi => 'جامعة العلوم الإسلامية، كراتشي';

  @override
  String get calculationMethodISNA => 'الجمعية الإسلامية لأمريكا الشمالية';

  @override
  String get calculationMethodMWL => 'رابطة العالم الإسلامي';

  @override
  String get calculationMethodMakkah => 'جامعة أم القرى، مكة المكرمة';

  @override
  String get calculationMethodEgypt => 'الهيئة المصرية العامة للمساحة';

  @override
  String get school => 'المذهب';

  @override
  String get schoolStandard => 'شافعي / مالكي / حنبلي';

  @override
  String get schoolHanafi => 'حنفي';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageUrdu => 'الأردية';

  @override
  String get currency => 'العملة';

  @override
  String get taraweeh => 'التراويح';

  @override
  String get quranTilawat => 'تلاوة القرآن';

  @override
  String get islamicStudy => 'درس إسلامي';

  @override
  String get morningEveningAdhkar => 'أذكار الصباح والمساء';

  @override
  String get surahMulk => 'سورة الملك';

  @override
  String get istighfar => 'الاستغفار';

  @override
  String get durood => 'الصلاة على النبي';

  @override
  String get subhanAllah => 'سبحان الله';

  @override
  String get sadaqah => 'الصدقة';

  @override
  String get addCustomItem => 'إضافة بند مخصص';

  @override
  String get fard => 'فرض';

  @override
  String get sunnah => 'سنة';

  @override
  String get jamah => 'جماعة';

  @override
  String get streak => 'تتابع';

  @override
  String get daysFull => 'أيام كاملة';

  @override
  String get update => 'تحديث';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get valueLabel => 'القيمة';

  @override
  String get day => 'يوم';

  @override
  String get ashra => 'عشرة';

  @override
  String get overall => 'إجمالي';

  @override
  String get greeting => 'السلام عليكم';

  @override
  String get guestUser => 'مستخدم';

  @override
  String get name => 'الاسم';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get hijri => 'هجري';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get errorDate => 'خطأ في تحميل التاريخ';

  @override
  String get saveProgress => 'حفظ التقدم';

  @override
  String get resetDay => 'إعادة تعيين اليوم؟';

  @override
  String resetDayContent(Object day) {
    return 'هل أنت متأكد أنك تريد إعادة تعيين اليوم $day؟ سيتم فقد كل التقدم لهذا اليوم.';
  }

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get tasbihName => 'اسم التسبيح';

  @override
  String get tasbihNameHint => 'مثال: سبحان الله';

  @override
  String get edit => 'تعديل';

  @override
  String get eveningReflection => 'انعكاس المساء';

  @override
  String get reflectionBest => 'أفضل لحظة';

  @override
  String get reflectionShortfall => 'ما قصرت فيه';

  @override
  String get reflectionSpecial => 'دعاء خاص دعوت به';

  @override
  String get reflectionGratitude => 'شيء واحد أنا ممتن له';

  @override
  String get resetAllDataTitle => 'إعادة تعيين جميع البيانات؟';

  @override
  String get resetAllDataContent =>
      'سيؤدي هذا إلى حذف جميع المتتبعات والأدعية والإعدادات الخاصة بك. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get resetAppData => 'إعادة تعيين بيانات التطبيق';

  @override
  String get locationDisabled => 'خدمات الموقع معطلة.';

  @override
  String get locationPermissionDenied => 'تم رفض أذونات الموقع';

  @override
  String get locationPermissionPermanent => 'تم رفض أذونات الموقع بشكل دائم.';

  @override
  String get detectingLocation => 'جار الكشف عن الموقع...';

  @override
  String locationError(Object error) {
    return 'خطأ في الكشف عن الموقع: $error';
  }

  @override
  String get settingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get allDataReset => 'تم إعادة تعيين جميع البيانات.';

  @override
  String dayTitle(Object day) {
    return 'اليوم $day';
  }

  @override
  String get ashra1 => 'العشرة الأولى (الرحمة)';

  @override
  String get ashra2 => 'العشرة الثانية (المغفرة)';

  @override
  String get ashra3 => 'العشرة الثالثة (العتق)';

  @override
  String get ashraTitle => 'عشرة';

  @override
  String get ashra1Title => 'العشرة الأولى';

  @override
  String get ashra1Subtitle => 'الرحمة';

  @override
  String get ashra2Title => 'العشرة الثانية';

  @override
  String get ashra2Subtitle => 'المغفرة';

  @override
  String get ashra3Title => 'العشرة الثالثة';

  @override
  String get ashra3Subtitle => 'العتق من النار';

  @override
  String get about => 'About App';

  @override
  String get developer => 'Developer';

  @override
  String get company => 'Company';

  @override
  String get appDescription =>
      'Ramadan Planner is your comprehensive spiritual companion designed to help you make the most of the holy month. Track your prayers, fasting, and daily ibadah with ease. Stay connected to your spiritual goals with features like Tasbih, Sadaqah tracking, and Quran reading logs. May this Ramadan be a source of barakah and growth for you.';

  @override
  String get version => 'Version';
}
