class AppConstants {
  static const String appName = 'Ramadan Planner';
  static const String hijriYear = '1447'; // Example, will be dynamic from API
  static const String ramadanBadge = 'Ramadan 2026';

  // Hive Box Names
  static const String settingsBox = 'settings_box';
  static const String plannerBox = 'planner_box';
  static const String cacheBox = 'cache_box';

  // API Endpoints (Base)
  static const String aladhanBaseUrl = 'https://api.aladhan.com/v1';
  static const String ummahApiBaseUrl =
      'https://api.ummahapi.com/v1'; // Example fallback
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1';
}
