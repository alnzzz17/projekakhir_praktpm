import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:projekakhir_praktpm/models/comment_model.dart';
import 'package:projekakhir_praktpm/presenters/comment_presenter.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';

class CommentSection extends StatefulWidget {
  final String newsId;
  const CommentSection({super.key, required this.newsId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  bool _isAddingComment = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
    });
    try {
      final commentPresenter = Provider.of<CommentPresenter>(context, listen: false);
      final comments = await commentPresenter.getCommentsByNewsId(widget.newsId);
      // Urutkan komentar terbaru (paling atas)
      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      _showErrorSnackbar('Gagal memuat komentar: $e');
    } finally {
      setState(() {
        _isLoadingComments = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      _showErrorSnackbar('Komentar tidak boleh kosong.');
      return;
    }

    final userPresenter = Provider.of<UserPresenter>(context, listen: false);
    final currentUser = userPresenter.currentUser;

    if (currentUser == null) {
      _showErrorSnackbar('Anda harus login untuk menambahkan komentar.');
      return;
    }

    setState(() {
      _isAddingComment = true;
    });

    try {
      final commentPresenter = Provider.of<CommentPresenter>(context, listen: false);
      final newComment = Comment(
        id: const Uuid().v4(),
        newsId: widget.newsId,
        userId: currentUser.id,
        username: currentUser.username,
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );
      await commentPresenter.addComment(newComment);
      _commentController.clear();
      await _loadComments();
      _showSuccessSnackbar('Komentar berhasil ditambahkan.');
    } catch (e) {
      _showErrorSnackbar('Gagal menambahkan komentar: $e');
    } finally {
      setState(() {
        _isAddingComment = false;
      });
    }
  }

  Future<void> _editComment(Comment comment) async {
    final TextEditingController editController = TextEditingController(text: comment.content);
    final bool? shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Komentar'),
          content: TextField(
            controller: editController,
            maxLines: null,
            decoration: const InputDecoration(hintText: 'Edit komentar Anda'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(true);
                } else {
                  _showErrorSnackbar('Komentar tidak boleh kosong.');
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (shouldUpdate == true && editController.text.trim().isNotEmpty) {
      try {
        final commentPresenter = Provider.of<CommentPresenter>(context, listen: false);
        final updatedComment = Comment(
          id: comment.id,
          newsId: comment.newsId,
          userId: comment.userId,
          username: comment.username,
          content: editController.text.trim(),
          createdAt: comment.createdAt,
        );
        await commentPresenter.updateComment(updatedComment);
        await _loadComments();
        _showSuccessSnackbar('Komentar berhasil diubah.');
      } catch (e) {
        _showErrorSnackbar('Gagal mengedit komentar: $e');
      }
    }
    editController.dispose();
  }

  Future<void> _deleteComment(String commentId) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Komentar'),
          content: const Text('Apakah Anda yakin ingin menghapus komentar ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerColor),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final commentPresenter = Provider.of<CommentPresenter>(context, listen: false);
        await commentPresenter.deleteComment(widget.newsId, commentId);
        await _loadComments(); 
        _showSuccessSnackbar('Komentar berhasil dihapus.');
      } catch (e) {
        _showErrorSnackbar('Gagal menghapus komentar: $e');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dangerColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPresenter = context.watch<UserPresenter>();
    final currentUser = userPresenter.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Komentar',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
        ),
        const SizedBox(height: AppPadding.mediumPadding),
        // Input Komentar
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Tambahkan komentar...',
            suffixIcon: _isAddingComment
                ? const Padding(
                    padding: EdgeInsets.all(AppPadding.smallPadding),
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentColor),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: AppColors.accentColor),
                    onPressed: _addComment,
                  ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: AppPadding.mediumPadding),
        // Daftar Komentar
        _isLoadingComments
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppPadding.mediumPadding),
                  child: CircularProgressIndicator(color: AppColors.accentColor),
                ),
              )
            : _comments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppPadding.mediumPadding),
                    child: Center(
                      child: Text(
                        'Belum ada komentar untuk berita ini.',
                        style: TextStyle(color: AppColors.hintColor),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      // Edit/Delete
                      final bool isMyComment = currentUser != null && currentUser.id == comment.userId;
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppPadding.smallPadding),
                        color: AppColors.softGrey,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.smallPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.username,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor,
                                        ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM. HH:mm').format(comment.createdAt),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.secondaryTextColor,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppPadding.extraSmallPadding),
                              Text(
                                comment.content,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.textColor,
                                    ),
                              ),
                              if (isMyComment)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 18, color: AppColors.accentColor),
                                      onPressed: () => _editComment(comment),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: 18, color: AppColors.dangerColor),
                                      onPressed: () => _deleteComment(comment.id),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ],
    );
  }
}