import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/views/news/news_list.dart';
import 'package:projekakhir_praktpm/views/news/bookmark_list.dart'; 
import 'package:projekakhir_praktpm/views/auth/profile_screen.dart'; 
import 'package:projekakhir_praktpm/utils/constants.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NewsListScreen(), 
    BookmarkListScreen(), 
    ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPresenter = context.watch<UserPresenter>();
    final currentUser = userPresenter.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? AppConstants.appName
            : _selectedIndex == 1
                ? 'Berita Favorit' 
                : 'Profil Pengguna'),
        actions: [
          if (currentUser != null && _selectedIndex == 2) 
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await userPresenter.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
        ],
      ),
      body: IndexedStack( 
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accentColor, 
        unselectedItemColor: AppColors.hintColor, 
        backgroundColor: AppColors.primaryColor, 
        onTap: _onItemTapped, 
      ),
    );
  }
}