import 'package:flutter/material.dart';
import 'package:pa_mobile/pages/main_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login hanya formalitas, semua input tetap bisa masuk ke halaman utama
  // (nanti diganti dengan pengecekan database)
  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea agar tidak tertutup notch
      body: SafeArea(
        // Stack menumpuk lingkaran dekorasi di belakang form
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -70,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: AppColors.redDark,
                  borderRadius: BorderRadius.circular(130),
                ),
              ),
            ),
            Positioned(
              top: 90,
              right: 40,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // SingleChildScrollView agar form bisa discroll saat keyboard muncul
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // Container logo toko
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.memory, size: 34, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'BengkelKOM',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const Text(
                      'Ridho',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.red),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rakit & upgrade PC impianmu dengan\nperalatan komputer terlengkap.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 40),

                    // Container card form login
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Silakan login untuk mulai berbelanja',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 24),

                          // Input username
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextField(
                              controller: usernameController,
                              cursorColor: AppColors.red,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                contentPadding: EdgeInsets.symmetric(vertical: 16),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.person_outline, size: 22, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Input password
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              cursorColor: AppColors.red,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                contentPadding: EdgeInsets.symmetric(vertical: 16),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.lock_outline, size: 22, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // SizedBox agar tombol memenuhi lebar card
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Masuk', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}