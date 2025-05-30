import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';

class BookmarkPresenter extends ChangeNotifier {
  static const String _bookmarksKey = 'news_bookmarks';

  List<News> _bookmarks = [];
  List<News> get bookmarks => _bookmarks;

  BookmarkPresenter() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final bookmarksJsonStrings = SharedPrefsService().prefs.getStringList(_bookmarksKey) ?? [];
      _bookmarks = bookmarksJsonStrings.map((jsonString) => News.fromJson(jsonDecode(jsonString))).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading bookmarks: $e');
      _bookmarks = [];
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final bookmarksJsonStrings = _bookmarks.map((news) => jsonEncode(news.toJson())).toList();
      await SharedPrefsService().prefs.setStringList(_bookmarksKey, bookmarksJsonStrings);
    } catch (e) {
      throw Exception('Failed to save bookmarks: $e');
    }
  }

  Future<void> addBookmark(News news) async {
    if (!_bookmarks.any((b) => b.url == news.url)) {
      _bookmarks.add(news);
      await _saveBookmarks();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String newsUrl) async {
    _bookmarks.removeWhere((b) => b.url == newsUrl);
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String newsUrl) {
    return _bookmarks.any((b) => b.url == newsUrl);
  }
}