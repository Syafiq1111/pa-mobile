import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/filter_chip_button.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

// Halaman kategori: filter berdasarkan merek dan urutan harga
class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedBrand = 'Semua';
  int sortMode = 0; // 0 default, 1 termurah, 2 termahal

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Semua produk pada kategori ini
        final categoryProducts = cart.products.where((product) {
          return product.category == widget.category.name;
        }).toList();

        // Set menyimpan merek unik tanpa duplikat
        final Set<String> brands = {};
        for (final product in categoryProducts) {
          brands.add(product.brand);
        }

        // Produk tampil: stok > 0 DAN sesuai merek yang dipilih
        final visibleProducts = categoryProducts.where((product) {
          return product.stock > 0 &&
              (selectedBrand == 'Semua' || product.brand == selectedBrand);
        }).toList();

        // Mengurutkan berdasarkan harga
        if (sortMode == 1) {
          visibleProducts.sort((a, b) => a.price.compareTo(b.price));
        } else if (sortMode == 2) {
          visibleProducts.sort((a, b) => b.price.compareTo(a.price));
        }

        // Scaffold dengan appBar untuk judul dan tombol kembali (Navigator.pop otomatis)
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: Colors.white,
            title: Text(
              widget.category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${cart.totalItems}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header kategori
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(widget.category.icon, size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.category.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              Text(
                                '${visibleProducts.length} produk • ${brands.length} merek',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter merek
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Merek',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      FilterChipButton(
                        label: 'Semua',
                        selected: selectedBrand == 'Semua',
                        onPressed: () => setState(() => selectedBrand = 'Semua'),
                      ),
                      for (final brand in brands)
                        FilterChipButton(
                          label: brand,
                          selected: selectedBrand == brand,
                          onPressed: () => setState(() => selectedBrand = brand),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Filter urutan harga
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Urutkan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      FilterChipButton(
                        label: 'Terlaris',
                        selected: sortMode == 0,
                        onPressed: () => setState(() => sortMode = 0),
                      ),
                      FilterChipButton(
                        label: 'Harga Terendah',
                        selected: sortMode == 1,
                        onPressed: () => setState(() => sortMode = 1),
                      ),
                      FilterChipButton(
                        label: 'Harga Tertinggi',
                        selected: sortMode == 2,
                        onPressed: () => setState(() => sortMode = 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Expanded agar daftar produk mengisi sisa ruang
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          if (visibleProducts.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'Produk tidak ditemukan',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          ProductGrid(products: visibleProducts),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}