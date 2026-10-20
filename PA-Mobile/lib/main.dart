import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:provider/provider.dart';
import 'package:pa_mobile/firebase_options.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/providers/theme_provider.dart';
import 'package:pa_mobile/pages/auth_gate.dart';
import 'package:pa_mobile/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase tidak mendukung Linux Desktop secara native.
  final isLinux = !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  if (!isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    isLinux
        ? const _UnsupportedPlatformApp()
        : MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => AddressProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: const MyApp(),
          ),
  );
}

// Layar info saat dijalankan di Linux Desktop
class _UnsupportedPlatformApp extends StatelessWidget {
  const _UnsupportedPlatformApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_android_rounded,
                      size: 44, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Jalankan di Android atau Web',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aplikasi ini menggunakan Firebase yang didukung di Android (HP/Emulator) dan Web (Chrome).\n\n'
                  'Jalankan langsung di HP via USB atau buka di Google Chrome.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'flutter run -d chrome  atau  flutter run',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'BengkelKOM',
      themeMode: themeProvider.themeMode,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorsDark.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColorsDark.primary,
          brightness: Brightness.dark,
        ).copyWith(
          surface: AppColorsDark.surface,
          primary: AppColorsDark.primary,
          onPrimary: AppColorsDark.background,
          secondary: AppColorsDark.secondary,
          onSecondary: AppColorsDark.background,
          error: AppColorsDark.danger,
        ),
        cardColor: const Color(0xFF1A1A1A),
        dividerColor: const Color(0xFF2A2A2A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF2A2A2A),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.danger,
        ),
        dividerColor: AppColors.border,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionHandleColor: AppColors.primary,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}