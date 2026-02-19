import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_planner/core/constants/app_constants.dart';

class AladhanApiClient {
  final http.Client _client;

  AladhanApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getTimingsByCity({
    required String city,
    required String country,
    int method = 1,
    int school = 1,
  }) async {
    final url = Uri.parse(
      '${AppConstants.aladhanBaseUrl}/timingsByCity?city=$city&country=$country&method=$method&school=$school',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load prayer times from Aladhan API');
    }
  }

  Future<Map<String, dynamic>> getCalendarByCity({
    required String city,
    required String country,
    required int month,
    required int year,
    int method = 1,
    int school = 1,
  }) async {
    final url = Uri.parse(
      '${AppConstants.aladhanBaseUrl}/calendarByCity?city=$city&country=$country&month=$month&year=$year&method=$method&school=$school',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load monthly calendar from Aladhan API');
    }
  }
}
