import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/filter_chip_button.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

// Halaman kategori: filter merek dan urutan harga.
// Ditampilkan oleh MainPage menggantikan Beranda (bukan Navigator.push),
// jadi hanya satu halaman yang hidup dan dirender pada satu waktu.
class CategoryPage extends StatefulWidget {
  final Category category;
  final VoidCallback onBack;

  const CategoryPage({super.key, required this.category, required this.onBack});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedBrand = 'Semua';
  int sortMode = 0; // 0 terlaris, 1 termurah, 2 termahal

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bar atas: tombol kembali dan nama kategori
        Container(
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
              Icon(widget.category.icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                widget.category.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              final categoryProducts = cart.products.where((product) {
                return product.category == widget.category.name;
              }).toList();

              final brands = categoryProducts.map((p) => p.brand).toSet().toList()
                ..sort();

              final visibleProducts = categoryProducts.where((product) {
                return selectedBrand == 'Semua' || product.brand == selectedBrand;
              }).toList();

              if (sortMode == 1) {
                visibleProducts.sort((a, b) => a.price.compareTo(b.price));
              } else if (sortMode == 2) {
                visibleProducts.sort((a, b) => b.price.compareTo(a.price));
              } else {
                visibleProducts.sort((a, b) => b.sold.compareTo(a.sold));
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${visibleProducts.length} produk • ${brands.length} merek',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          _label('Merek'),
                          const SizedBox(height: 6),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
                          const SizedBox(height: 10),
                          _label('Urutkan'),
                          const SizedBox(height: 6),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
                        ],
                      ),
                    ),
                  ),
                  if (cart.isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else if (visibleProducts.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'Produk tidak ditemukan',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverProductGrid(products: visibleProducts),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
    );
  }
}