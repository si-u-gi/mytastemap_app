import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

Future<List<dynamic>> fetchStores(double lat, double lng) async {
  final url = "$baseUrl/location/stores?lat=$lat&lng=$lng";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["documents"]; // ✅ 카카오 JSON의 documents 배열
  } else {
    throw Exception("Spring 서버 오류: ${response.statusCode}");
  }
}