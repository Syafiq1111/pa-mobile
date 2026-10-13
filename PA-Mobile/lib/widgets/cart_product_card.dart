import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/theme/app_colors.dart';

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

  // initState: membuat controller dengan jumlah awal
  @override
  void initState() {
    super.initState();
    quantityController =
        TextEditingController(text: '${widget.quantity}');
  }

  // didUpdateWidget: menyamakan TextField jika quantity berubah dari luar card
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
    if (parsed == null || parsed < 1) return;

    final clamped = parsed.clamp(1, widget.maxQuantity);
    if (clamped != parsed) {
      quantityController.text = '$clamped';
      quantityController.selection =
          TextSelection.collapsed(offset: quantityController.text.length);
    }
    widget.onQuantityChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(product.image, width: 84, height: 84, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.red),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  formatRupiah(product.price),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Kolom input jumlah dan tombol hapus
          Column(
            children: [
              // SizedBox mengatur lebar input jumlah
              SizedBox(
                width: 56,
                child: TextField(
                  controller: quantityController,
                  // Input hanya angka
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  cursorColor: AppColors.red,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  onChanged: updateQuantity,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 56,
                child: ElevatedButton(
                  onPressed: widget.onRemove,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.surfaceLight,
                    foregroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Icon(Icons.delete_outline, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}