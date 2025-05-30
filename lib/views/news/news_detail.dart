import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:projekakhir_praktpm/models/news_model.dart';
import 'package:projekakhir_praktpm/presenters/bookmark_presenter.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';
import 'package:projekakhir_praktpm/views/comments/comment_section.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
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

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      _showErrorSnackbar('Tidak dapat membuka URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkPresenter = context.watch<BookmarkPresenter>();
    final userPresenter = context.watch<UserPresenter>();
    final currentUser = userPresenter.currentUser;
    
    bool isBookmarked = currentUser != null 
        ? bookmarkPresenter.isBookmarked(currentUser.id, widget.news.url)
        : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.accentColor : AppColors.textColor,
            ),
            onPressed: () {
              if (currentUser == null) {
                _showErrorSnackbar('Anda harus login untuk menambahkan favorit');
                return;
              }

              if (isBookmarked) {
                bookmarkPresenter.removeBookmark(currentUser.id, widget.news.url);
                _showSuccessSnackbar('Berita dihapus dari favorit.');
              } else {
                bookmarkPresenter.addBookmark(currentUser.id, widget.news);
                _showSuccessSnackbar('Berita ditambahkan ke favorit.');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.news.title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
            ),
            const SizedBox(height: AppPadding.smallPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.news.source,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  DateFormat('dd MMM. HH:mm').format(widget.news.publishedAt),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.mediumPadding),
            if (widget.news.urlToImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                child: Image.network(
                  widget.news.urlToImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.softGrey,
                      child: Icon(Icons.image_not_supported, 
                          color: AppColors.hintColor, size: 50),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppPadding.mediumPadding),
            Text(
              widget.news.description.isNotEmpty 
                  ? widget.news.description 
                  : 'Tidak ada deskripsi tersedia.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textColor,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppPadding.largePadding),
            Text(
              widget.news.content.isNotEmpty
                  ? (widget.news.content.length > 200
                      ? '${widget.news.content.substring(0, 200)}...'
                      : widget.news.content)
                  : 'Tidak ada konten lengkap yang tersedia.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textColor,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppPadding.largePadding),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _launchUrl(widget.news.url),
                icon: const Icon(Icons.open_in_new, color: AppColors.linkColor),
                label: Text(
                  'Baca Selengkapnya',
                  style: TextStyle(
                      color: AppColors.linkColor, 
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(
                height: AppPadding.extraLargePadding, 
                thickness: 1, 
                color: AppColors.softGrey),
            CommentSection(newsId: widget.news.url),
          ],
        ),
      ),
    );
  }
}