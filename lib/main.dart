import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';
import 'package:projekakhir_praktpm/views/auth/login.dart';
import 'package:projekakhir_praktpm/views/auth/register.dart';
import 'package:projekakhir_praktpm/views/news/news_list.dart';
import 'package:projekakhir_praktpm/views/news/news_detail.dart';
import 'package:projekakhir_praktpm/models/news_model.dart';

void main() async {
  // Pastikan binding Flutter diinisialisasi sebelum mengakses SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi SharedPreferencesService
  await SharedPrefsService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App with Comments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/news': (context) => NewsListScreen(),
        '/news-detail': (context) {
          final news = ModalRoute.of(context)!.settings.arguments as News;
          return NewsDetailScreen(news: news);
        },
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: SharedPrefsService().getCurrentUser(),
      builder: (context, snapshot) {
        // Periksa status koneksi
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Jika sudah selesai loading
        if (snapshot.connectionState == ConnectionState.done) {
          // Jika user sudah login, arahkan ke NewsList
          if (snapshot.hasData) {
            return NewsListScreen();
          } 
          // Jika belum login, arahkan ke LoginScreen
          else {
            return LoginScreen();
          }
        }
        
        // Fallback untuk state lainnya
        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}