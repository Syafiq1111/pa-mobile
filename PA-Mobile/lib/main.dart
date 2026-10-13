import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/pages/login_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';

void main() {
  runApp(
    // MultiProvider untuk tempat mendaftarkan provider yang dibutuhkan
    MultiProvider(
      providers: [
        // ChangeNotifierProvider membuat dan menyediakan CartProvider ke semua widget di bawahnya
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget wrapper utama aplikasi
    return MaterialApp(
      title: 'BengkelKOM-Ridho',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        // Warna kursor & blok teks di semua TextField
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.accent,
          selectionHandleColor: AppColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        // Navigasi bawah: label aktif berwarna cyan
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final active = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? AppColors.accent : AppColors.textSecondary,
            );
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: const TextStyle(color: AppColors.textPrimary),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Halaman pertama adalah login
      home: const LoginPage(),
    );
  }
}