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
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Halaman pertama adalah login
      home: const LoginPage(),
    );
  }
}