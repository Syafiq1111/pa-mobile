import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/models/purchase_order.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/utils/format_date.dart';

// Menampilkan riwayat pembelian berdasarkan data pesanan hasil checkout.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text(
          'Riwayat Pembelian',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        // Memperbarui tampilan ketika data pesanan pada CartProvider berubah.
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Menampilkan pesan ketika belum ada riwayat pembelian.
                    if (cart.orders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: context.appBorder,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada riwayat pembelian',
                              style: TextStyle(
                                fontSize: 14,
                                color: context.appTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Menampilkan setiap pesanan dalam bentuk kartu.
                    for (final order in cart.orders) ...[
                      _buildOrderCard(context, order),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Menyusun kartu pesanan yang berisi detail transaksi dan pengiriman.
  Widget _buildOrderCard(BuildContext context, PurchaseOrder order) {
    // Warna teks di atas badge hijau gelap pada mode gelap, putih pada mode terang.
    final onAccent = context.isDarkMode ? AppColorsDark.background : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan nomor pesanan dan status transaksi.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.appTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.appSuccess,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: onAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          // Memformat tanggal transaksi agar mudah dibaca.
          Text(
            formatTanggal(order.date),
            style: TextStyle(
              fontSize: 11,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Menampilkan nama, merek, jumlah, harga, dan subtotal barang.
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: context.appTextPrimary,
                          ),
                        ),
                        Text(
                          '${item.brand} • ${item.quantity} x ${formatRupiah(item.price)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatRupiah(item.subtotal),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.appTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

          // Memisahkan daftar barang dari informasi pengiriman.
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: 1,
            color: context.appBorder,
          ),

          // Menampilkan alamat tujuan pengiriman pesanan.
          Text(
            'Dikirim ke',
            style: TextStyle(
              fontSize: 11,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            order.address,
            style: TextStyle(
              fontSize: 12,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Menampilkan total biaya seluruh barang dalam pesanan.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12,
                  color: context.appTextSecondary,
                ),
              ),
              Text(
                formatRupiah(order.total),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.appPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}