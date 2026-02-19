import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_planner/core/constants/app_constants.dart';

class OpenMeteoApiClient {
  final http.Client _client;

  OpenMeteoApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getCurrentWeather({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse(
      '${AppConstants.weatherBaseUrl}/forecast?latitude=$lat&longitude=$lng&current_weather=true',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather from Open-Meteo');
    }
  }
}
