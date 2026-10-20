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
    // Warna ikon/teks di atas warna aksen: gelap pada mode gelap (aksen terang),
    // putih pada mode terang (aksen gelap), agar selalu terbaca.
    final onAccent = context.isDarkMode ? AppColorsDark.background : Colors.white;

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
              color: context.appSuccess,
              borderRadius: AppStyle.card,
            ),
            child: Icon(
              Icons.check,
              size: 38,
              color: onAccent,
            ),
          ),
          const SizedBox(height: 24),

          // Menampilkan informasi bahwa pembayaran telah berhasil.
          Text(
            'Pembayaran Berhasil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.appTextPrimary,
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
              color: context.appSurface,
              border: Border.all(color: context.appBorder),
              borderRadius: AppStyle.card,
            ),
            child: Column(
              children: [
                // Label untuk menjelaskan nilai yang ditampilkan.
                Text(
                  'Total pembayaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),

                // Memformat total pembayaran ke dalam mata uang Rupiah.
                Text(
                  formatRupiah(total),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.appTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Menampilkan ucapan terima kasih kepada pelanggan.
          Text(
            'Terima kasih sudah berbelanja di BengkelKOM-Ridho',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: context.appTextSecondary,
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
                backgroundColor: context.appPrimary,
                foregroundColor: onAccent,
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