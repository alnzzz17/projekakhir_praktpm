import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekakhir_praktpm/network/api_constants.dart';

class NewsApi {
  Future<Map<String, dynamic>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/everything?q=$query&apiKey=${ApiConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<Map<String, dynamic>> getNewsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/top-headlines?category=$category&apiKey=${ApiConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load news by category');
    }
  }
}