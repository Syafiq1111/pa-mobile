import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/widgets/product_card.dart';

// Grid 2 kolom versi sliver: card hanya dibuat saat mendekati layar (lazy),
// jadi membuka halaman dengan banyak produk tetap ringan.
// Pakai di dalam CustomScrollView.slivers (bungkus SliverPadding jika perlu).
class SliverProductGrid extends StatelessWidget {
  final List<Product> products;

  const SliverProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) => ProductCard(
          key: ValueKey(products[index].id),
          product: products[index],
        ),
        childCount: products.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: ProductCard.height,
      ),
    );
  }
}