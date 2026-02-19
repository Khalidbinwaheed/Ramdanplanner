import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>?> getCurrentWeather(
    double lat,
    double long,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m,weather_code',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        return {
          'temp': current['temperature_2m'],
          'code': current['weather_code'],
        };
      }
    } catch (e) {
      // In production, log error
    }
    return null;
  }

  String getWeatherDescription(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Partly Cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain Showers';
    if (code <= 86) return 'Snow Showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }
}
