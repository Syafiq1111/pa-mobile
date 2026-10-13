import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/cart_product_card.dart';

class CartPage extends StatefulWidget {
  final VoidCallback onCheckout;

  const CartPage({super.key, required this.onCheckout});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Consumer mendengarkan perubahan CartProvider
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Produk di keranjang yang nama/mereknya mengandung searchQuery
        final cartItems = cart.cartProducts.where((product) {
          return product.name.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);
        }).toList();

        return Column(
          children: [
            // Header judul dan pencarian
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keranjang',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cart.totalItems} item siap dibeli',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      cursorColor: AppColors.red,
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (value) =>
                          setState(() => searchQuery = value.toLowerCase()),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Cari di keranjang',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.search, size: 22, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expanded agar daftar keranjang mengisi sisa ruang
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (cartItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.border),
                              SizedBox(height: 12),
                              Text(
                                'Keranjang masih kosong',
                                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      for (final product in cartItems) ...[
                        CartProductCard(
                          product: product,
                          quantity: cart.cartQuantities[product.id] ?? 0,
                          // jumlah maksimal = yang sudah di keranjang + sisa stok
                          maxQuantity: (cart.cartQuantities[product.id] ?? 0) + product.stock,
                          onQuantityChanged: (value) =>
                              context.read<CartProvider>().changeQuantity(product, value),
                          onRemove: () =>
                              context.read<CartProvider>().removeFromCart(product),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bar total dan checkout dengan BoxShadow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        formatRupiah(cart.grandTotal),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  // Tombol checkout hanya aktif jika Grand Total lebih dari 0
                  ElevatedButton(
                    onPressed: cart.grandTotal > 0 ? widget.onCheckout : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.surfaceLight,
                      disabledForegroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Checkout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}