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
  final ScrollController _scrollController = ScrollController(); 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsPresenter>(context, listen: false).getAllNews();
    });

    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        
        _loadMoreNews();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); 
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

  void _loadMoreNews() {
    final newsPresenter = Provider.of<NewsPresenter>(context, listen: false);
    if (!newsPresenter.isLoading && newsPresenter.hasMoreNews) {
      
      if (_searchController.text.trim().isNotEmpty) {
        newsPresenter.searchNews(_searchController.text.trim(), isLoadMore: true);
      } else {
        newsPresenter.getNewsByCategory(_selectedCategory, isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.textColor, fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: AppConstants.searchHint,
                    prefixIcon: const Icon(Icons.search, color: AppColors.hintColor, size: 20.0),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softGrey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softGrey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accentColor, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.primaryColor,
                    focusColor: AppColors.primaryColor,
                    hoverColor: AppColors.primaryColor,
                    labelStyle: TextStyle(color: AppColors.hintColor, fontSize: 12.0),
                    hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 12.0),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.hintColor, size: 20.0),
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
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    foregroundColor: AppColors.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding, vertical: AppPadding.mediumPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppPadding.tinyPadding),
                    ),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Cari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Filter Kategori
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            style: TextStyle(color: AppColors.textColor),
            dropdownColor: AppColors.primaryColor,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.softGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.softGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accentColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding),
              filled: true,
              fillColor: AppColors.primaryColor,
            ),
            items: <String>[
              'general', 'business', 'entertainment', 'health', 'science', 'sports', 'technology'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value[0].toUpperCase() + value.substring(1),
                  style: TextStyle(color: AppColors.textColor),
                ),
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
              if (newsPresenter.newsList.isEmpty && newsPresenter.isLoading) {
                
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
                  controller: _scrollController, 
                  itemCount: newsPresenter.newsList.length + (newsPresenter.hasMoreNews ? 1 : 0), 
                  itemBuilder: (context, index) {
                    if (index == newsPresenter.newsList.length) {
                      
                      return newsPresenter.isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppPadding.mediumPadding),
                                child: CircularProgressIndicator(color: AppColors.accentColor),
                              ),
                            )
                          : const SizedBox.shrink(); 
                    }
                    final news = newsPresenter.newsList[index];
                    return NewsCard(news: news);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}


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
          
          Navigator.pushNamed(
            context,
            '/news-detail',
            arguments: news, 
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                child: news.urlToImage.isNotEmpty
                    ? Image.network(
                        news.urlToImage,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset( 
                            'assets/images/noCover.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset( 
                        'assets/images/noCover.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: AppPadding.smallPadding),
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
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    DateFormat('dd MMM. HH:mm').format(news.publishedAt),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.hintColor,
                          fontStyle: FontStyle.italic,
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