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
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final cartItems = cart.cartProducts.where((product) {
          return product.name.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);
        }).toList();

        return Column(
          children: [
            // Header judul dan pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keranjang',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cart.totalItems} item siap dibeli',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: AppStyle.card,
                    ),
                    child: TextField(
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (value) =>
                          setState(() => searchQuery = value.trim().toLowerCase()),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Cari di keranjang',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                        prefixIcon: Icon(Icons.search, size: 22, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Daftar keranjang lazy (ListView.builder) dan mengisi sisa ruang
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.border),
                    const SizedBox(height: 10),
                    Text(
                      cart.cartProducts.isEmpty
                          ? 'Keranjang masih kosong'
                          : 'Tidak ada hasil pencarian',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return CartProductCard(
                    key: ValueKey(product.id),
                    product: product,
                    quantity: cart.cartQuantities[product.id] ?? 0,
                    // jumlah maksimal = stok asli di database
                    maxQuantity: product.stock,
                    onQuantityChanged: (value) =>
                        context.read<CartProvider>().changeQuantity(product, value),
                    onRemove: () =>
                        context.read<CartProvider>().removeFromCart(product),
                  );
                },
              ),
            ),

            // Bar total dan checkout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
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
                  // Aktif jika ada isi keranjang dan checkout tidak sedang diproses
                  ElevatedButton(
                    onPressed: cart.grandTotal > 0 && !cart.isCheckingOut
                        ? widget.onCheckout
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.surfaceLight,
                      disabledForegroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppStyle.small),
                    ),
                    child: cart.isCheckingOut
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textSecondary),
                    )
                        : const Text('Checkout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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