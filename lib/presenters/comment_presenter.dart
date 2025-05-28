import 'package:shared_preferences/shared_preferences.dart';
import 'package:projekakhir_praktpm/models/comment_model.dart';

class CommentPresenter {
  final SharedPreferences prefs;

  CommentPresenter(this.prefs);

  Future<List<Comment>> getCommentsByNewsId(String newsId) async {
    final comments = prefs.getStringList('comments') ?? [];
    return comments
        .map((commentString) => Comment.fromMap(Map<String, dynamic>.from(commentString as Map)))
        .where((comment) => comment.newsId == newsId)
        .toList();
  }

  Future<bool> addComment(Comment comment) async {
    try {
      final comments = prefs.getStringList('comments') ?? [];
      comments.add(comment.toMap().toString());
      await prefs.setStringList('comments', comments);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateComment(Comment updatedComment) async {
    try {
      final comments = prefs.getStringList('comments') ?? [];
      final index = comments.indexWhere((commentString) {
        final comment = Comment.fromMap(Map<String, dynamic>.from(commentString as Map));
        return comment.id == updatedComment.id;
      });

      if (index != -1) {
        comments[index] = updatedComment.toMap().toString();
        await prefs.setStringList('comments', comments);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      final comments = prefs.getStringList('comments') ?? [];
      comments.removeWhere((commentString) {
        final comment = Comment.fromMap(Map<String, dynamic>.from(commentString as Map));
        return comment.id == commentId;
      });
      await prefs.setStringList('comments', comments);
      return true;
    } catch (e) {
      return false;
    }
  }
}