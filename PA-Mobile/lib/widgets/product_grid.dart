import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/widgets/product_card.dart';

// Menyusun produk menjadi 2 kolom menggunakan Row dan Column
class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 2) {
      final hasSecond = i + 1 < products.length;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ProductCard(product: products[i])),
            const SizedBox(width: 12),
            // Jika jumlah ganjil, kolom kedua dikosongkan
            Expanded(
              child: hasSecond
                  ? ProductCard(product: products[i + 1])
                  : const SizedBox(),
            ),
          ],
        ),
      );
      rows.add(const SizedBox(height: 12));
    }

    return Column(children: rows);
  }
}