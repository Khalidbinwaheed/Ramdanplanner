import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_planner/core/constants/app_constants.dart';

class UmmahApiClient {
  final http.Client _client;

  UmmahApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getPrayerTimes({
    required double lat,
    required double lng,
    String madhab = 'Hanafi',
    String method = 'MuslimWorldLeague',
  }) async {
    final url = Uri.parse(
      '${AppConstants.ummahApiBaseUrl}/prayer-times?lat=$lat&lng=$lng&madhab=$madhab&method=$method',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load prayer times from UmmahAPI');
    }
  }

  Future<Map<String, dynamic>> getHijriDate(String date) async {
    final url = Uri.parse(
      '${AppConstants.ummahApiBaseUrl}/hijri-date?date=$date',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Hijri date from UmmahAPI');
    }
  }
}
