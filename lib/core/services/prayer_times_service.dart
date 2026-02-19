import 'package:adhan/adhan.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';

class PrayerTimesService {
  PrayerTimes getPrayerTimes({
    required double latitude,
    required double longitude,
    required ShellUserSettings settings,
    DateTime? date,
  }) {
    final myCoordinates = Coordinates(latitude, longitude);
    final params = _getCalculationMethod(settings.calculationMethod);
    params.madhab = settings.asrSchool == 1 ? Madhab.hanafi : Madhab.shafi;

    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    return prayerTimes;
  }

  CalculationParameters _getCalculationMethod(int methodId) {
    switch (methodId) {
      case 1:
        return CalculationMethod.karachi.getParameters();
      case 2:
        return CalculationMethod.north_america.getParameters();
      case 3:
        return CalculationMethod.muslim_world_league.getParameters();
      case 4:
        return CalculationMethod.umm_al_qura.getParameters();
      case 5:
        return CalculationMethod.egyptian.getParameters();
      default:
        return CalculationMethod.karachi.getParameters();
    }
  }
}
