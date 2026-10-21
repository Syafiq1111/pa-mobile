import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/providers/favorite_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch halaman diperbarui saat favorit atau data produk berubah.
    final favorites = context.watch<FavoriteProvider>();
    final cart = context.watch<CartProvider>();

    // Produk yang ditandai favorit, diambil dari daftar produk Firestore.
    final products =
    cart.products.where((product) => favorites.isFavorite(product.id)).toList();

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text(
          'Produk Favorit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: cart.isLoading
        // Menunggu data produk selesai dimuat.
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
        // Tampilan kosong beserta petunjuk cara menambah favorit.
            ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: context.appBorder,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada produk favorit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tekan ikon hati pada produk di Beranda untuk menyimpannya di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        )
        // Daftar produk favorit dalam grid 2 kolom.
            : CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverProductGrid(products: products),
            ),
          ],
        ),
      ),
    );
  }
}