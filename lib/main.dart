import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// UtiS
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';
import 'package:projekakhir_praktpm/utils/constants.dart'; 

// Network 
import 'package:projekakhir_praktpm/network/api_service.dart';

// Presenters
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/presenters/news_presenter.dart';
import 'package:projekakhir_praktpm/presenters/comment_presenter.dart';
import 'package:projekakhir_praktpm/presenters/bookmark_presenter.dart';

// Models
import 'package:projekakhir_praktpm/models/user_model.dart';
import 'package:projekakhir_praktpm/models/news_model.dart'; 

// Views
import 'package:projekakhir_praktpm/views/auth/login.dart';
import 'package:projekakhir_praktpm/views/auth/register.dart';
import 'package:projekakhir_praktpm/views/home_wrapper.dart'; 

import 'package:projekakhir_praktpm/views/news/news_detail.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init();

  runApp(
    MultiProvider(
      providers: [
        Provider<NewsApi>(create: (_) => NewsApi()),

        ChangeNotifierProvider(
          create: (context) => UserPresenter(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsPresenter(context.read<NewsApi>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentPresenter(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookmarkPresenter(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName, // Mengambil nama aplikasi dari konstanta
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug di pojok kanan atas

      // Definisi tema aplikasi
      theme: ThemeData(
        // primarySwatch biasanya digunakan untuk menghasilkan berbagai shade warna material
        // Tapi kita bisa menimpa warna di AppBarTheme untuk kontrol lebih halus dengan warna custom
        primarySwatch: Colors.blue, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Konfigurasi AppBar secara global
        appBarTheme: const AppBarTheme(
          elevation: 0, // Menghilangkan shadow di AppBar
          centerTitle: true, // Judul di tengah
          backgroundColor: AppColors.primaryColor, 
          foregroundColor: AppColors.textColor, 
          titleTextStyle: TextStyle( 
            color: AppColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textColor),
          bodyMedium: TextStyle(color: AppColors.textColor),
        ),
        
        cardTheme: CardTheme(
          color: AppColors.primaryColor, 
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppPadding.smallPadding),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppPadding.smallPadding),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppPadding.smallPadding),
            borderSide: BorderSide(color: AppColors.softGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppPadding.smallPadding),
            borderSide: BorderSide(color: AppColors.softGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppPadding.smallPadding),
            borderSide: BorderSide(color: AppColors.accentColor, width: 2),
          ),
          filled: true,
          fillColor: AppColors.primaryColor, 
          hintStyle: TextStyle(color: AppColors.hintColor),
          labelStyle: TextStyle(color: AppColors.textColor),
          prefixIconColor: AppColors.hintColor,
        ),
      ),

      initialRoute: '/', 
      routes: {
        '/': (context) => const AuthWrapper(), 
        '/login': (context) => const LoginScreen(), 
        '/register': (context) => const RegisterScreen(), 
        '/home': (context) => const HomeWrapper(), 
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
    final userPresenter = Provider.of<UserPresenter>(context, listen: false);

    return FutureBuilder<User?>(
      future: userPresenter.getLoggedInUser(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.accentColor),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeWrapper(); 
          } else {
            return const LoginScreen(); 
          }
        }

        return Scaffold(
          body: Center(
            child: Text(
              AppConstants.genericErrorMessage,
              style: TextStyle(color: AppColors.textColor),
            ),
          ),
        );
      },
    );
  }
}