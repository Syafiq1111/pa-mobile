import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Halaman hasil checkout yang menampilkan status pembayaran dan total belanja.
class TotalPage extends StatelessWidget {
  final int total;
  final VoidCallback onBack;

  const TotalPage({
    super.key,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Memberikan jarak pada sisi kiri dan kanan halaman.
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Menampilkan ikon sebagai penanda pembayaran berhasil.
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: AppStyle.card,
            ),
            child: const Icon(
              Icons.check,
              size: 38,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Menampilkan informasi bahwa pembayaran telah berhasil.
          const Text(
            'Pembayaran Berhasil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Card yang menampilkan ringkasan total pembayaran.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: AppStyle.card,
            ),
            child: Column(
              children: [
                // Label untuk menjelaskan nilai yang ditampilkan.
                const Text(
                  'Total pembayaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),

                // Memformat total pembayaran ke dalam mata uang Rupiah.
                Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Menampilkan ucapan terima kasih kepada pelanggan.
          const Text(
            'Terima kasih sudah berbelanja di BengkelKOM-Ridho',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),

          // Tombol untuk kembali ke halaman beranda.
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              // Menjalankan fungsi yang diberikan melalui parameter onBack.
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppStyle.small,
                ),
              ),
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}