import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/utils/auth_messages.dart';
import 'package:pa_mobile/widgets/auth_text_field.dart';

// Halaman pendaftaran akun.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Mengelola nilai dari setiap kolom formulir.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  // Menyimpan status proses dan validasi formulir.
  bool isLoading = false;
  String errorMessage = '';
  bool obscurePassword = true;
  bool agreeTerms = true;

  // Melepaskan controller saat halaman ditutup.
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // Menentukan tingkat kekuatan sandi berdasarkan panjangnya.
  int get passwordStrength {
    final text = passwordController.text;
    if (text.isEmpty) return 0;
    if (text.length < 6) return 1;
    if (text.length < 10) return 2;
    return 3;
  }

  // Label untuk tingkat kekuatan sandi.
  String get strengthLabel {
    switch (passwordStrength) {
      case 1:
        return 'Kurang Lemah';
      case 2:
        return 'Cukup Baik';
      case 3:
        return 'Sangat Kuat';
      default:
        return 'Belum diisi';
    }
  }

  // Warna indikator mengikuti tingkat kekuatan sandi.
  Color get strengthColor {
    switch (passwordStrength) {
      case 1:
        return AppColors.danger;
      case 2:
        return AppColors.secondaryContainer;
      case 3:
        return AppColors.primary;
      default:
        return AppColors.outline;
    }
  }

  // Memvalidasi data lalu membuat akun melalui Firebase Authentication.
  Future<void> register() async {
    // Pastikan kolom wajib sudah diisi.
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      setState(() => errorMessage = 'Semua kolom wajib diisi');
      return;
    }

    // Pendaftaran hanya dilanjutkan jika syarat disetujui.
    if (!agreeTerms) {
      setState(() => errorMessage = 'Harap menyetujui syarat & ketentuan');
      return;
    }

    // Periksa kesesuaian kata sandi dan konfirmasinya.
    if (passwordController.text != confirmController.text) {
      setState(() => errorMessage = 'Konfirmasi password tidak sama');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Buat akun menggunakan email dan kata sandi.
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Simpan nama pengguna jika kolom nama diisi.
      if (nameController.text.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(nameController.text.trim());
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil, selamat datang!')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = authErrorMessage(e.code);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status kecocokan sandi untuk indikator konfirmasi.
    final passwordsMatch = confirmController.text.isNotEmpty &&
        confirmController.text == passwordController.text;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dekorasi latar belakang.
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryFixed.withValues(alpha: 0.3),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Navigasi dan judul halaman.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded,
                              size: 22, color: AppColors.textPrimary),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            shadowColor: Colors.black12,
                            elevation: 1,
                          ),
                        ),
                        const Text(
                          'Buat Akun Baru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Bantuan pendaftaran: Hubungi CS BengkelKOM di 0812-5890-XXXX'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.help_outline_rounded,
                              size: 22, color: AppColors.primary),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            shadowColor: Colors.black12,
                            elevation: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Ilustrasi identitas pada bagian pembuka.
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                          ),
                          child: Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryContainer,
                              ),
                              child: const Icon(
                                Icons.person_add_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -2,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryContainer,
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Identitas lokasi layanan.
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'BengkelKOM Samarinda',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Mulai Pengalaman Belanja',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nikmati garansi resmi, poin cashback, serta layanan servis & perakitan PC prioritas di Samarinda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Kartu utama formulir pendaftaran.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppStyle.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Akun',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Lengkapi data untuk daftar instan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Langkah 1/1',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Input nama pengguna.
                          AuthTextField(
                            controller: nameController,
                            label: 'Nama Lengkap',
                            hint: 'Contoh: Muhammad Rizky',
                            icon: Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: 14),

                          // Input email untuk autentikasi.
                          AuthTextField(
                            controller: emailController,
                            label: 'Alamat Email',
                            hint: 'nama@email.com',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 14),

                          // Input sandi dengan kontrol visibilitas.
                          AuthTextField(
                            controller: passwordController,
                            label: 'Kata Sandi',
                            hint: 'Minimal 6 karakter',
                            icon: Icons.lock_outline_rounded,
                            obscure: obscurePassword,
                            onChanged: (_) => setState(() {}),
                            suffix: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.outline,
                              ),
                              onPressed: () => setState(
                                      () => obscurePassword = !obscurePassword),
                            ),
                          ),

                          // Indikator kekuatan sandi.
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kekuatan Sandi:',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                strengthLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: strengthColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              for (int i = 1; i <= 3; i++) ...[
                                Expanded(
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: passwordStrength >= i
                                          ? strengthColor
                                          : AppColors.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                if (i < 3) const SizedBox(width: 6),
                              ],
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Input untuk memastikan sandi sesuai.
                          AuthTextField(
                            controller: confirmController,
                            label: 'Konfirmasi Sandi',
                            hint: 'Ulangi kata sandi',
                            icon: Icons.verified_user_outlined,
                            obscure: obscurePassword,
                            onChanged: (_) => setState(() {}),
                            suffix: confirmController.text.isNotEmpty
                                ? Icon(
                              passwordsMatch
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              size: 20,
                              color: passwordsMatch
                                  ? AppColors.primary
                                  : AppColors.danger,
                            )
                                : null,
                          ),

                          const SizedBox(height: 12),

                          // Persetujuan syarat dan kebijakan privasi.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: agreeTerms,
                                  onChanged: (v) =>
                                      setState(() => agreeTerms = v ?? true),
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Saya menyetujui ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary),
                                    children: [
                                      TextSpan(
                                        text: 'Syarat & Ketentuan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(text: ' serta '),
                                      TextSpan(
                                        text: 'Kebijakan Privasi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(text: ' BengkelKOM.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Tampilkan pesan jika validasi atau autentikasi gagal.
                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 16, color: AppColors.danger),
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

                          // Tombol untuk mengirim formulir.
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: AppColors.primary.withValues(alpha: 0.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 18),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Akses kembali ke halaman masuk.
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Sudah punya akun? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Masuk di sini',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informasi hak cipta dan alamat.
                    const SizedBox(height: 24),
                    const Text(
                      '© 2026 BengkelKOM. Jl. P. Antasari, Samarinda.',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
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