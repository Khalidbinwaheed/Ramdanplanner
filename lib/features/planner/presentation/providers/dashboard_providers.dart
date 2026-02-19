import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/core/services/prayer_times_service.dart';
import 'package:ramadan_planner/core/services/weather_service.dart';

// Services Providers
final prayerTimesServiceProvider = Provider((ref) => PrayerTimesService());
final weatherServiceProvider = Provider((ref) => WeatherService());

// State Classes
class DashboardState {
  final PrayerTimes? prayerTimes;
  final HijriCalendar hijriDate;
  final Map<String, dynamic>? weather;

  DashboardState({this.prayerTimes, required this.hijriDate, this.weather});
}

// Main Provider
final dashboardProvider = FutureProvider<DashboardState>((ref) async {
  final settings = ref.watch(settingsViewModelProvider);
  final prayerService = ref.read(prayerTimesServiceProvider);
  final weatherService = ref.read(weatherServiceProvider);

  // 1. Get Location
  double? lat = settings.latitude;
  double? long = settings.longitude;

  // Default to Makkah if no location set
  if (lat == null || long == null) {
    // Makkah Coordinates
    lat = 21.3891;
    long = 39.8579;
  }

  // 2. Get Prayer Times
  final prayerTimes = prayerService.getPrayerTimes(
    latitude: lat,
    longitude: long,
    settings: settings,
  );

  // 3. Get Weather (only if location is valid/detected)
  Map<String, dynamic>? weather;
  if (settings.latitude != null && settings.longitude != null) {
    // Cache or simple fetch. Ideally cached, but for now direct fetch.
    // To avoid spamming API on every rebuild, we might want to separate this.
    // But FutureProvider caches until dependencies change.
    // Settings changes trigger refresh.
    weather = await weatherService.getCurrentWeather(lat, long);
  }

  // 4. Get Hijri Date
  final hijri = HijriCalendar.now();

  return DashboardState(
    prayerTimes: prayerTimes,
    hijriDate: hijri,
    weather: weather,
  );
});
