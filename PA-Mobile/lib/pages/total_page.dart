import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Halaman hasil checkout, menampilkan total belanja
class TotalPage extends StatelessWidget {
  final int total;
  final VoidCallback onBack;

  const TotalPage({super.key, required this.total, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack menumpuk lingkaran luar di belakang lingkaran icon
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  right: 28,
                  top: 28,
                  bottom: 28,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(52),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.redDark,
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 52, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Pembayaran Berhasil',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Total',
            style: TextStyle(fontSize: 26, color: AppColors.textPrimary),
          ),
          Text(
            formatRupiah(total),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.red),
          ),
          const SizedBox(height: 8),
          const Text(
            'Terima kasih sudah berbelanja di BengkelKOM-Ridho',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}