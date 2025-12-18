import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

Future<List<dynamic>> fetchStores({
  double minRating = 0,
  int minReview = 0,
}) async {
  final uri = Uri.parse(
    "$baseUrl/location/stores"
    "?minRating=$minRating&minReview=$minReview",
  );

  final response = await http.get(uri);
  final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  return decoded;
}
