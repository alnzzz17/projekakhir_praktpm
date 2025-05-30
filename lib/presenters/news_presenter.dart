import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/network/api_service.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';

class NewsPresenter extends ChangeNotifier {
  final NewsApi newsApi;
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  NewsPresenter(this.newsApi);

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchNews(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _newsList = await newsApi.searchNews(query);
    } catch (e) {
      _errorMessage = 'Failed to search news: $e';
      _newsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNewsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _newsList = await newsApi.getNewsByCategory(category);
    } catch (e) {
      _errorMessage = 'Failed to load news by category: $e';
      _newsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _newsList = await newsApi.getTopHeadlines();
    } catch (e) {
      _errorMessage = 'Failed to load all news: $e';
      _newsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}