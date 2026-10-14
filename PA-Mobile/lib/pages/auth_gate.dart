import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_mobile/pages/login_page.dart';
import 'package:pa_mobile/pages/main_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// AuthGate memantau status login secara otomatis
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // authStateChanges() menghasilkan stream yang berubah saat login, logout, atau daftar
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Menunggu Firebase memeriksa sesi yang tersimpan
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          );
        }

        // Ada sesi (sudah login) -> halaman utama, jika tidak -> halaman login
        if (snapshot.hasData) {
          return const MainPage();
        }
        return const LoginPage();
      },
    );
  }
}