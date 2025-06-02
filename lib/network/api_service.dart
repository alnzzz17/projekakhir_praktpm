// lib/network/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekakhir_praktpm/network/api_constants.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';

class NewsApi {
  Future<List<News>> searchNews(String query, {int page = 1, int pageSize = 20}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/everything?q=$query&page=$page&pageSize=$pageSize&apiKey=${ApiConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok' && data['articles'] != null) {
        final articles = data['articles'] as List;
        return articles.map((article) => News.fromJson(article)).toList();
      } else {
        throw Exception('API Error: ${data['message'] ?? 'Unknown error'} (Status Code: ${response.statusCode})');
      }
    } else {
      throw Exception('Failed to load news: HTTP Status Code ${response.statusCode}');
    }
  }

  Future<List<News>> getNewsByCategory(String category, {int page = 1, int pageSize = 20}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/top-headlines?category=$category&page=$page&pageSize=$pageSize&apiKey=${ApiConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok' && data['articles'] != null) {
        final articles = data['articles'] as List;
        return articles.map((article) => News.fromJson(article)).toList();
      } else {
        throw Exception('API Error: ${data['message'] ?? 'Unknown error'} (Status Code: ${response.statusCode})');
      }
    } else {
      throw Exception('Failed to load news by category: HTTP Status Code ${response.statusCode}');
    }
  }

  Future<List<News>> getTopHeadlines({int page = 1, int pageSize = 20}) async {
    return getNewsByCategory('general', page: page, pageSize: pageSize);
  }
}