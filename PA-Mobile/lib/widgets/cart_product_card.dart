import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/product_image.dart';

// Card produk di keranjang, Stateful karena memegang TextEditingController jumlah
class CartProductCard extends StatefulWidget {
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

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '${widget.quantity}');
  }

  // Menyamakan TextField jika quantity berubah dari luar card
  @override
  void didUpdateWidget(covariant CartProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity &&
        quantityController.text != '${widget.quantity}') {
      quantityController.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  // Validasi: ubah teks jadi angka, batasi 1 sampai maxQuantity
  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1 || widget.maxQuantity < 1) return;

    final clamped = parsed.clamp(1, widget.maxQuantity);
    if (clamped != parsed) {
      quantityController.text = '$clamped';
      quantityController.selection =
          TextSelection.collapsed(offset: quantityController.text.length);
    }
    widget.onQuantityChanged(clamped);
  }

  // Tombol - dan +
  void step(int delta) {
    if (widget.maxQuantity < 1) return;
    final next = (widget.quantity + delta).clamp(1, widget.maxQuantity);
    if (next != widget.quantity) widget.onQuantityChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppStyle.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppStyle.small,
            child: ProductImage(path: product.image, width: 84, height: 84),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatRupiah(product.price),
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: widget.quantity > 1 ? () => step(-1) : null,
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 44,
                      height: 30,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        onChanged: updateQuantity,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 7),
                          filled: true,
                          fillColor: AppColors.surface,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppStyle.small,
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppStyle.small,
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: widget.quantity < widget.maxQuantity ? () => step(1) : null,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: widget.onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                      icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
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

// Tombol kotak kecil untuk menambah / mengurangi jumlah
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: AppStyle.small),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 16,
            color: onTap == null ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}