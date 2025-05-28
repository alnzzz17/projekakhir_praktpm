import 'package:projekakhir_praktpm/network/api_service.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';

class NewsPresenter {
  final NewsApi newsApi;

  NewsPresenter(this.newsApi);

  Future<List<News>> searchNews(String query) async {
    try {
      final response = await newsApi.searchNews(query);
      final articles = response['articles'] as List;
      return articles.map((article) => News.fromJson(article)).toList();
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }

  Future<List<News>> getNewsByCategory(String category) async {
    try {
      final response = await newsApi.getNewsByCategory(category);
      final articles = response['articles'] as List;
      return articles.map((article) => News.fromJson(article)).toList();
    } catch (e) {
      throw Exception('Failed to load news by category: $e');
    }
  }
}