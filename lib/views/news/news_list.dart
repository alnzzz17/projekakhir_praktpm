import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/presenters/news_presenter.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';
import 'package:intl/intl.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    // Memuat berita
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsPresenter>(context, listen: false).getAllNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<NewsPresenter>(context, listen: false).searchNews(query);
      _selectedCategory = '';
    } else {
      Provider.of<NewsPresenter>(context, listen: false).getAllNews();
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
    });
    Provider.of<NewsPresenter>(context, listen: false).getNewsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.mediumPadding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppConstants.searchHint,
                      prefixIcon: const Icon(Icons.search, color: AppColors.hintColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.hintColor),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch(); 
                              },
                            )
                          : null,
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: AppPadding.smallPadding),
                ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding, vertical: AppPadding.smallPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                    ),
                  ),
                  child: const Text('Cari'),
                ),
              ],
            ),
          ),
          // Filter Kategori (opsional, bisa diganti dengan Chip atau Horizontal ListView)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding),
              ),
              items: <String>[
                'general', 'business', 'entertainment', 'health', 'science', 'sports', 'technology'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value[0].toUpperCase() + value.substring(1)), 
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _filterByCategory(newValue);
                }
              },
            ),
          ),
          const SizedBox(height: AppPadding.mediumPadding),
          Expanded(
            child: Consumer<NewsPresenter>(
              builder: (context, newsPresenter, child) {
                if (newsPresenter.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.accentColor));
                } else if (newsPresenter.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.mediumPadding),
                      child: Text(
                        '${AppConstants.genericErrorMessage}\n${newsPresenter.errorMessage}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.dangerColor),
                      ),
                    ),
                  );
                } else if (newsPresenter.newsList.isEmpty) {
                  return const Center(
                    child: Text(
                      AppConstants.noNewsFound,
                      style: TextStyle(color: AppColors.secondaryTextColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: newsPresenter.newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsPresenter.newsList[index];
                      return NewsCard(news: news); 
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan satu item berita dalam daftar
class NewsCard extends StatelessWidget {
  final News news;
  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding, vertical: AppPadding.smallPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppPadding.smallPadding),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail berita
          Navigator.pushNamed(
            context,
            '/news-detail',
            arguments: news, // Kirim objek berita sebagai argumen
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.urlToImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                  child: Image.network(
                    news.urlToImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.softGrey,
                        child: Icon(Icons.image_not_supported, color: AppColors.hintColor, size: 50),
                      );
                    },
                  ),
                ),
              if (news.urlToImage.isNotEmpty) const SizedBox(height: AppPadding.smallPadding),
              Text(
                news.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppPadding.extraSmallPadding),
              Text(
                news.description.isNotEmpty ? news.description : 'Tidak ada deskripsi tersedia.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.secondaryTextColor,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppPadding.smallPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    news.source,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(news.publishedAt),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.hintColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}