import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/models/comment_model.dart';
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';

class CommentPresenter extends ChangeNotifier {
  CommentPresenter();

  Future<List<Comment>> getCommentsByNewsId(String newsId) async {
    try {
      final comments = await SharedPrefsService().getComments(newsId);
      return comments;
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<void> addComment(Comment comment) async {
    try {
      await SharedPrefsService().addComment(comment.newsId, comment);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> updateComment(Comment updatedComment) async {
    try {
      await SharedPrefsService().updateComment(updatedComment.newsId, updatedComment);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  Future<void> deleteComment(String newsId, String commentId) async {
    try {
      await SharedPrefsService().deleteComment(newsId, commentId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}