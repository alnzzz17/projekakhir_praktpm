import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/presenters/bookmark_presenter.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart'; // Untuk mengecek status login
import 'package:projekakhir_praktpm/models/news_model.dart'; // Diperlukan untuk NewsCard
import 'package:projekakhir_praktpm/utils/constants.dart';
import 'package:projekakhir_praktpm/views/news/news_list.dart'; // Menggunakan NewsCard dari sini

class BookmarkListScreen extends StatefulWidget {
  const BookmarkListScreen({super.key});

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPresenter = context.watch<UserPresenter>();
    final currentUser = userPresenter.currentUser;

    if (currentUser == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: AppColors.hintColor),
              const SizedBox(height: AppPadding.mediumPadding),
              Text(
                'Anda harus login untuk melihat berita favorit.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: AppPadding.mediumPadding),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Login Sekarang'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Consumer<BookmarkPresenter>(
        builder: (context, bookmarkPresenter, child) {
          if (bookmarkPresenter.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 80, color: AppColors.hintColor),
                  const SizedBox(height: AppPadding.mediumPadding),
                  Text(
                    'Belum ada berita yang Anda favoritkan.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: AppPadding.smallPadding),
                  Text(
                    'Anda bisa menambahkan berita ke favorit dari halaman detail berita.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.hintColor),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: bookmarkPresenter.bookmarks.length,
              itemBuilder: (context, index) {
                final news = bookmarkPresenter.bookmarks[index];
                return NewsCard(news: news);
              },
            );
          }
        },
      ),
    );
  }
}