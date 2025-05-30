import 'package:flutter/material.dart';

// --- AppConstants ---
class AppConstants {
  static const String appName = 'Berita Kita';
  static const String genericErrorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String noInternetMessage = 'Tidak ada koneksi internet. Silakan periksa koneksi Anda.';
  static const String noNewsFound = 'Tidak ada berita ditemukan.';
  static const String searchHint = 'Cari berita...';
  static const String appSubtitle = 'Dapatkan berita terbaru, cepat dan mudah.';
}

// --- AppColors ---
class AppColors {
  static const Color primaryColor = Color(0xFFFFFFFF); // Putih (untuk background, dll)
  static const Color accentColor = Color(0xFF1A73E8); // Biru (untuk tombol, highlight)
  static const Color textColor = Color(0xFF202124); // Abu-abu gelap (untuk teks utama)
  static const Color secondaryTextColor = Color(0xFF5F6368); // Abu-abu sedang (untuk teks sekunder)
  static const Color hintColor = Color(0xFF9AA0A6); // Abu-abu muda (untuk hint text)
  static const Color softGrey = Color(0xFFF2F2F2); // Abu-abu sangat muda (untuk background input, card)
  static const Color dangerColor = Color(0xFFFF4D4F); // Merah (untuk error/bahaya)
  static const Color successColor = Color(0xFF52C41A); // Hijau (untuk sukses)
  static const Color linkColor = Color(0xFF1A73E8); // Biru (untuk link)
}

// --- AppPadding ---
class AppPadding {
  static const double extraSmallPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
}

// --- AppAssets --- (Opsional, jika ada gambar atau aset lain)
// class AppAssets {
//   static const String logo = 'assets/images/logo.png';
//   static const String placeholderImage = 'assets/images/placeholder.png';
// }