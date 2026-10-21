import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_mobile/pages/register_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/utils/auth_messages.dart';
import 'package:pa_mobile/widgets/app_logo.dart';
import 'package:pa_mobile/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menyimpan input email dan kata sandi pengguna.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Menyimpan status proses login dan pesan kesalahan autentikasi.
  bool isLoading = false;
  String errorMessage = '';

  // Mengatur visibilitas kata sandi dan status pilihan Ingat Saya.
  bool obscurePassword = true;
  bool rememberMe = true;

  @override
  void dispose() {
    // Melepaskan controller agar tidak menggunakan memori setelah halaman ditutup.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Memvalidasi input dan melakukan autentikasi menggunakan Firebase.
  Future<void> login() async {
    // Memastikan email dan kata sandi telah diisi sebelum login diproses.
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Email dan kata sandi wajib diisi');
      return;
    }

    // Mengaktifkan indikator loading dan menghapus pesan kesalahan sebelumnya.
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Memverifikasi akun menggunakan email dan kata sandi melalui Firebase.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // Menampilkan pesan kesalahan sesuai kode error dari Firebase.
      if (!mounted) return;
      setState(() => errorMessage = authErrorMessage(e.code));
    }

    // Menghentikan indikator loading jika halaman masih aktif.
    if (mounted) setState(() => isLoading = false);
  }

  // Membuka halaman pendaftaran akun baru.
  void openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dekorasi lingkaran pastel sebagai latar belakang halaman login.
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: -70,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryFixed.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            top: 360,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiaryFixed.withValues(alpha: 0.3),
              ),
            ),
          ),

          // Menjaga konten tetap berada di area aman layar dan dapat digulir.
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    // Menampilkan informasi lokasi cabang BengkelKOM.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Samarinda • Cabang Antasari',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Menampilkan logo, nama merek, dan deskripsi layanan.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo dari assets/images/logo.png
                        const AppLogo(size: 54, radius: 18, showShadow: true),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Bengkel',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'KOM',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Solusi IT & Komputer Terpercaya',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.outline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Menampilkan salam dan informasi singkat bagi pengguna.
                    const Text(
                      'Selamat Datang Kembali! 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Masuk untuk belanja sparepart dan servis komputer terbaik se-Samarinda.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Kartu utama yang menampung seluruh formulir login.
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppStyle.cardShadow,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Garis dekoratif dengan warna gradien di bagian atas kartu.
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: AppColors.heroBarGradient,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul formulir autentikasi pengguna.
                                const Center(
                                  child: Text(
                                    'Masuk Akun',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // Kolom input email akun pengguna.
                                AuthTextField(
                                  controller: emailController,
                                  label: 'Email Akun',
                                  hint: 'nama@email.com',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const SizedBox(height: 14),

                                // Kolom kata sandi dengan tombol untuk mengubah visibilitas.
                                AuthTextField(
                                  controller: passwordController,
                                  label: 'Kata Sandi',
                                  hint: 'Masukkan kata sandi akun',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: obscurePassword,
                                  suffix: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 20,
                                      color: AppColors.outline,
                                    ),
                                    onPressed: () => setState(
                                          () => obscurePassword = !obscurePassword,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Menyediakan pilihan Ingat Saya dan Lupa Sandi.
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(
                                            () => rememberMe = !rememberMe,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: Checkbox(
                                              value: rememberMe,
                                              onChanged: (v) => setState(
                                                    () => rememberMe = v ?? true,
                                              ),
                                              activeColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Ingat Saya',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Menampilkan pemberitahuan saat opsi lupa sandi dipilih.
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Fitur Reset Password dikirimkan ke email Anda.',
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Lupa Sandi?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Menampilkan pesan kesalahan jika validasi atau login gagal.
                                if (errorMessage.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.errorContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 16,
                                          color: AppColors.danger,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            errorMessage,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.danger,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 18),

                                // Tombol login dengan gradien dan indikator proses.
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: isLoading
                                      // Menampilkan animasi selama proses login berlangsung.
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      // Menampilkan label dan ikon saat tombol siap digunakan.
                                          : const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Masuk ke Akun',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Mengarahkan pengguna yang belum memiliki akun ke halaman pendaftaran.
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Belum punya akun? ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: openRegister,
                                        child: const Text(
                                          'Daftar Sekarang',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.secondary,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Menampilkan informasi hak cipta dan alamat cabang.
                    const Center(
                      child: Text(
                        '© 2026 BengkelKOM. Jl. P. Antasari, Samarinda.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}