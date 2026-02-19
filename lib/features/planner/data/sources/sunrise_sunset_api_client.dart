import 'dart:convert';
import 'package:http/http.dart' as http;

class SunriseSunsetApiClient {
  final http.Client _client;

  SunriseSunsetApiClient({http.Client? client})
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getSunriseSunset({
    required double lat,
    required double lng,
    String date = 'today',
  }) async {
    final url = Uri.parse(
      'https://api.sunrise-sunset.org/json?lat=$lat&lng=$lng&date=$date&formatted=0',
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sunrise/sunset data');
    }
  }
}
