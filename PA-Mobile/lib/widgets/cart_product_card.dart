import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/product_image.dart';

// Card item keranjang sesuai desain modern BengkelKOM
class CartProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final int maxQuantity;
  final void Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  void step(int delta) {
    if (maxQuantity < 1) return;
    final next = (quantity + delta).clamp(1, maxQuantity);
    if (next != quantity) onQuantityChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppStyle.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: context.appSurfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: ProductImage(
              path: product.image,
              width: 76,
              height: 76,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: context.appPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete_outline_rounded,
                            size: 18, color: context.appOutline.withValues(alpha: 0.8)),
                      ),
                    ),
                  ],
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
                Text(
                  'Stok: $maxQuantity unit',
                  style: TextStyle(fontSize: 11, color: context.appTextSecondary),
                ),
                SizedBox(height: 6),

                // Price and Modern Stepper Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatRupiah(product.price),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: context.appPrimary,
                      ),
                    ),

                    // Stepper Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.appSurfaceContainerLow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: quantity > 1 ? () => step(-1) : null,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.appSurface,
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 14,
                                color: quantity > 1
                                    ? context.appTextPrimary
                                    : context.appOutlineVariant,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: context.appTextPrimary,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: quantity < maxQuantity ? () => step(1) : null,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: quantity < maxQuantity
                                    ? context.appPrimaryContainer
                                    : context.appSurfaceContainerHighest,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}