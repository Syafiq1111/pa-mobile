import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/providers/favorite_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/product_image.dart';

// Card produk versi grid modern BengkelKOM dengan modal konfirmasi keranjang
class ProductCard extends StatelessWidget {
  static const double height = 300;
  static const double imageHeight = 120;

  final Product product;

  const ProductCard({super.key, required this.product});

  // Modal konfirmasi sebelum memasukkan item ke keranjang
  void _showAddToCartDialog(BuildContext context, int availableStock, int inCart) {
    int selectedQty = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final subtotal = product.price * selectedQty;

            return Container(
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                20 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),

                  // Header Modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Konfirmasi Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: context.appTextPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                        icon: Icon(Icons.close_rounded,
                            size: 20, color: context.appOutline),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Info Produk
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.appSurfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ProductImage(
                            path: product.image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brand.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: context.appPrimary,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: context.appTextPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                formatRupiah(product.price),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: context.appPrimary,
                                ),
                              ),
                              Text(
                                inCart > 0
                                    ? 'Sisa $availableStock unit ($inCart di keranjang)'
                                    : 'Stok tersedia: $availableStock unit',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: context.appTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18),

                  // Kuantitas Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jumlah',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.appTextPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.appSurfaceContainerLow,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: selectedQty > 1
                                  ? () => setModalState(() => selectedQty--)
                                  : null,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedQty > 1
                                      ? Colors.white
                                      : context.appSurfaceContainerHigh,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: selectedQty > 1
                                      ? context.appTextPrimary
                                      : context.appOutlineVariant,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '$selectedQty',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: context.appTextPrimary,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: selectedQty < availableStock
                                  ? () => setModalState(() => selectedQty++)
                                  : null,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedQty < availableStock
                                      ? context.appPrimary
                                      : context.appSurfaceContainerHighest,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(color: context.appBorderSubtle),
                  SizedBox(height: 8),

                  // Subtotal & Tombol Tambah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 11,
                              color: context.appTextSecondary,
                            ),
                          ),
                          Text(
                            formatRupiah(subtotal),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: context.appPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final cart = context.read<CartProvider>();
                              final newQty = inCart + selectedQty;
                              cart.changeQuantity(product, newQty);

                              Navigator.pop(modalContext);

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded,
                                            color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '$selectedQty ${product.name} dimasukkan ke keranjang',
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: context.appPrimaryDark,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    duration: Duration(milliseconds: 1200),
                                  ),
                                );
                            },
                            icon: Icon(Icons.add_shopping_cart_rounded, size: 18),
                            label: Text(
                              'Tambah ke Keranjang',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final available =
    context.select<CartProvider, int>((cart) => cart.availableStock(product));
    final inCart =
    context.select<CartProvider, int>((cart) => cart.cartQuantities[product.id] ?? 0);
    final soldOut = product.stock <= 0;

    return Container(
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appBorderSubtle, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container
                Container(
                  width: double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: context.appSurfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ProductImage(
                        path: product.image,
                        height: imageHeight,
                        fit: BoxFit.contain,
                      ),
                      if (soldOut)
                        Positioned.fill(
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.8),
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.appTextPrimary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'HABIS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                // Rating & Terjual
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 15, color: Color(0xFFE69B00)),
                    SizedBox(width: 3),
                    Text(
                      '${product.rating}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: context.appTextPrimary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '• ${product.sold} terjual',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.appOutline,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                // Product Name
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.appTextPrimary,
                    height: 1.2,
                  ),
                ),

                // Brand / Category Tag
                Text(
                  product.brand.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: context.appPrimary,
                  ),
                ),

                Spacer(),

                // Price
                Text(
                  formatRupiah(product.price),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),

                SizedBox(height: 6),

                // Tombol + Keranjang (selalu konsisten dan bersih di katalog)
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: available <= 0
                      ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.appSurfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      soldOut ? 'Habis' : 'Maks. di keranjang',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.appOutline,
                      ),
                    ),
                  )
                      : ElevatedButton.icon(
                    onPressed: () => _showAddToCartDialog(context, available, inCart),
                    icon: Icon(
                      inCart > 0
                          ? Icons.shopping_bag_rounded
                          : Icons.add_shopping_cart_rounded,
                      size: 14,
                    ),
                    label: Text(
                      inCart > 0 ? '+ Keranjang ($inCart)' : '+ Keranjang',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: inCart > 0
                          ? context.appPrimary.withValues(alpha: 0.15)
                          : context.appPrimary.withValues(alpha: 0.1),
                      foregroundColor: context.appPrimary,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol favorit: ditekan untuk menyimpan / menghapus produk dari favorit
          Positioned(
            top: 6,
            left: 6,
            child: _FavoriteButton(product: product),
          ),
        ],
      ),
    );
  }
}

// Tombol hati pada kartu produk.
// Area sentuh 44px agar mudah ditekan, tampilan lingkaran tetap 28px.
class _FavoriteButton extends StatelessWidget {
  final Product product;

  const _FavoriteButton({required this.product});

  @override
  Widget build(BuildContext context) {
    // select: hanya tombol ini yang dibangun ulang saat status favorit berubah.
    final isFavorite = context
        .select<FavoriteProvider, bool>((fav) => fav.isFavorite(product.id));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<FavoriteProvider>().toggle(product);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? '${product.name} dihapus dari favorit'
                    : '${product.name} ditambahkan ke favorit',
              ),
              duration: const Duration(milliseconds: 900),
            ),
          );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.9),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 16,
            color: isFavorite ? const Color(0xFFE53935) : context.appOutline,
          ),
        ),
      ),
    );
  }
}