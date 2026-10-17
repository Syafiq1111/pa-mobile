import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/filter_chip_button.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

class MyHomePage extends StatefulWidget {
  // Dipanggil saat kategori ditekan; MainPage yang mengganti halaman,
  // sehingga Beranda ditutup (bukan menumpuk di belakang halaman kategori)
  final void Function(Category category) onCategoryTap;

  const MyHomePage({super.key, required this.onCategoryTap});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchQuery = '';
  String selectedCategory = 'Semua'; // filter kategori pada daftar produk

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final visibleProducts = cart.products.where((product) {
          final matchCategory =
              selectedCategory == 'Semua' || product.category == selectedCategory;
          final matchSearch = product.name.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);
          return matchCategory && matchSearch;
        }).toList();

        // CustomScrollView + sliver: produk dibuat lazy (hanya yang terlihat).
        // PageStorageKey menyimpan posisi scroll saat kembali dari halaman kategori.
        return CustomScrollView(
          key: const PageStorageKey<String>('home_scroll'),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildProductHeader(visibleProducts.length)),
            if (cart.isLoading)
              SliverToBoxAdapter(child: _statusBox(const CircularProgressIndicator()))
            else if (cart.errorMessage != null)
              SliverToBoxAdapter(
                child: _statusBox(
                  Text(
                    cart.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
              )
            else if (visibleProducts.isEmpty)
                SliverToBoxAdapter(
                  child: _statusBox(
                    const Text(
                      'Produk tidak ditemukan',
                      style: TextStyle(color: AppColors.textSecondary),
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
    );
  }

  Widget _statusBox(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(child: child),
    );
  }

  // Header: nama toko dan pencarian
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.memory, size: 26, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'BengkelKOM-Ridho',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Rakit & upgrade PC impianmu',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                hintText: 'Cari produk atau merek',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                contentPadding: EdgeInsets.symmetric(vertical: 13),
                prefixIcon: Icon(Icons.search, size: 22, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Banner datar tanpa dekorasi lingkaran
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppStyle.card,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROMO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Upgrade PC lebih hemat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 2),
            Text(
              'Diskon hingga 30% untuk SSD & RAM pilihan',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            'Kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categoryList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categoryList[index];
              return _CategoryTile(
                category: category,
                onTap: () => widget.onCategoryTap(category),
              );
            },
          ),
        ),
      ],
    );
  }

  // Judul daftar produk dan filter kategori
  Widget _buildProductHeader(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                '$count produk',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChipButton(
                label: 'Semua',
                selected: selectedCategory == 'Semua',
                onPressed: () => setState(() => selectedCategory = 'Semua'),
              ),
              for (final category in categoryList)
                FilterChipButton(
                  label: category.name,
                  selected: selectedCategory == category.name,
                  onPressed: () => setState(() => selectedCategory = category.name),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// Kotak kategori: icon dan label
class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.card,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 26, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}