import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch mendengarkan perubahan CartProvider
    final cart = context.watch<CartProvider>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header profil, Stack dan Positioned untuk dekorasi
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.redDark,
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(Icons.person, size: 36, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ridho',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ridho@bengkelkom.id',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Row ringkasan keranjang
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        Icons.shopping_bag_outlined,
                        '${cart.totalItems}',
                        'Item Keranjang',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.payments_outlined,
                        formatRupiah(cart.grandTotal),
                        'Total Belanja',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildMenuItem(Icons.location_on_outlined, 'Alamat Pengiriman'),
                const SizedBox(height: 10),
                _buildMenuItem(Icons.receipt_long_outlined, 'Riwayat Pembelian'),
                const SizedBox(height: 10),
                _buildMenuItem(Icons.support_agent, 'Bantuan'),
                const SizedBox(height: 24),

                // Tombol keluar kembali ke halaman login dengan Navigator.pop
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 18),
                        SizedBox(width: 8),
                        Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget kartu ringkasan: icon, nilai, dan label
  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.red),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // Widget baris menu: icon, judul, dan panah
  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}