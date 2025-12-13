import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

Future<List<dynamic>> fetchStores(double lat, double lng) async {
  final uri = Uri.parse(
    "$baseUrl/location/stores?lat=$lat&lng=$lng",
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
    final decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);
    return data['documents'] as List<dynamic>;
  } else {
    throw Exception("Spring 서버 오류: ${response.statusCode}");
  }
}
