// lib/presenters/news_presenter.dart
import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/network/api_service.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';

class NewsPresenter extends ChangeNotifier {
  final NewsApi newsApi;
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1; 
  final int _pageSize = 100; 
  bool _hasMoreNews = true; 
  String _currentQuery = ''; 
  String _currentCategory = 'general'; 

  NewsPresenter(this.newsApi);

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMoreNews => _hasMoreNews; 

  
  void _resetPagination() {
    _currentPage = 1;
    _hasMoreNews = true;
    _newsList = []; 
    _errorMessage = null;
  }

  Future<void> searchNews(String query, {bool isLoadMore = false}) async {
    if (_isLoading) return; 

    if (!isLoadMore) {
      _resetPagination();
      _currentQuery = query;
      _currentCategory = ''; 
    } else if (!_hasMoreNews) {
      return; 
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newArticles = await newsApi.searchNews(_currentQuery, page: _currentPage, pageSize: _pageSize);
      if (newArticles.isEmpty || newArticles.length < _pageSize) {
        _hasMoreNews = false; 
      } else {
        _currentPage++; 
      }
      _newsList.addAll(newArticles); 
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to search news: $e';
      if (!isLoadMore) { 
        _newsList = [];
      }
      _hasMoreNews = false; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNewsByCategory(String category, {bool isLoadMore = false}) async {
    if (_isLoading) return; 
    if (!isLoadMore) {
      _resetPagination();
      _currentCategory = category;
      _currentQuery = ''; 
    } else if (!_hasMoreNews) {
      return; 
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newArticles = await newsApi.getNewsByCategory(_currentCategory, page: _currentPage, pageSize: _pageSize);
      if (newArticles.isEmpty || newArticles.length < _pageSize) {
        _hasMoreNews = false; 
      } else {
        _currentPage++; 
      }
      _newsList.addAll(newArticles); 
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load news by category: $e';
      if (!isLoadMore) { 
        _newsList = [];
      }
      _hasMoreNews = false; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllNews({bool isLoadMore = false}) async {
    // Memanggil getNewsByCategory dengan kategori 'general'
    await getNewsByCategory('general', isLoadMore: isLoadMore);
  }
}