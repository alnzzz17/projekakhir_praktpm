import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';

class BookmarkPresenter extends ChangeNotifier {
  static const String _bookmarksKey = 'news_bookmarks';
  List<Bookmark> _bookmarks = [];

  List<News> getBookmarksForUser(String userId) {
    return _bookmarks
        .where((bookmark) => bookmark.userId == userId)
        .map((bookmark) => bookmark.news)
        .toList();
  }

  BookmarkPresenter() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final bookmarksJsonStrings =
          SharedPrefsService().prefs.getStringList(_bookmarksKey) ?? [];
      _bookmarks = bookmarksJsonStrings
          .map((jsonString) => Bookmark.fromJson(jsonDecode(jsonString)))
          .toList();
      notifyListeners();
    } catch (e) {
      // Use debugPrint for logging in Flutter instead of print
      debugPrint('Error loading bookmarks: $e');
      _bookmarks = [];
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final bookmarksJsonStrings =
          _bookmarks.map((bookmark) => jsonEncode(bookmark.toJson())).toList();
      await SharedPrefsService().prefs.setStringList(
            _bookmarksKey,
            bookmarksJsonStrings,
          );
    } catch (e) {
      throw Exception('Failed to save bookmarks: $e');
    }
  }

  Future<void> addBookmark(String userId, News news) async {
    if (!_bookmarks.any((b) => b.news.url == news.url && b.userId == userId)) {
      _bookmarks.add(Bookmark(userId: userId, news: news));
      await _saveBookmarks();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String userId, String newsUrl) async {
    _bookmarks.removeWhere((b) => b.news.url == newsUrl && b.userId == userId);
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String userId, String newsUrl) {
    return _bookmarks.any((b) => b.news.url == newsUrl && b.userId == userId);
  }
}