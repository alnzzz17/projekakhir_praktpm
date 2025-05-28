import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:projekakhir_praktpm/models/user_model.dart';
import 'package:projekakhir_praktpm/models/comment_model.dart';

class SharedPrefsService {
  // Singleton pattern dengan lazy initialization
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // User methods
  Future<void> saveUser(User user) async {
    try {
      await init();
      await _prefs.setString('current_user', json.encode(user.toJson()));
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      await init();
      final userJson = _prefs.getString('current_user');
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> logout() async {
    try {
      await init();
      await _prefs.remove('current_user');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Comments methods
  Future<void> saveComments(String newsId, List<Comment> comments) async {
    try {
      await init();
      final commentsJson = comments.map((c) => c.toJson()).toList();
      await _prefs.setString('comments_$newsId', json.encode(commentsJson));
    } catch (e) {
      throw Exception('Failed to save comments: $e');
    }
  }

  Future<List<Comment>> getComments(String newsId) async {
    try {
      await init();
      final commentsJson = _prefs.getString('comments_$newsId');
      if (commentsJson != null) {
        final List<dynamic> decoded = json.decode(commentsJson);
        return decoded.map((json) => Comment.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  // Tambahkan metode untuk operasi individual comment
  Future<void> addComment(String newsId, Comment comment) async {
    final comments = await getComments(newsId);
    comments.add(comment);
    await saveComments(newsId, comments);
  }

  Future<void> updateComment(String newsId, Comment updatedComment) async {
    final comments = await getComments(newsId);
    final index = comments.indexWhere((c) => c.id == updatedComment.id);
    if (index != -1) {
      comments[index] = updatedComment;
      await saveComments(newsId, comments);
    }
  }

  Future<void> deleteComment(String newsId, String commentId) async {
    final comments = await getComments(newsId);
    comments.removeWhere((c) => c.id == commentId);
    await saveComments(newsId, comments);
  }
}