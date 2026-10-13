import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/pages/category_page.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/filter_chip_button.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchQuery = '';
  String selectedCategory = 'Semua'; // filter kategori pada daftar produk

  @override
  Widget build(BuildContext context) {
    // Consumer mendengarkan perubahan CartProvider, builder dijalankan ulang saat notifyListeners()
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Produk tampil: stok > 0, sesuai kategori, DAN nama/merek mengandung searchQuery
        final visibleProducts = cart.products.where((product) {
          final matchCategory =
              selectedCategory == 'Semua' || product.category == selectedCategory;
          final matchSearch = product.name.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);
          return product.stock > 0 && matchCategory && matchSearch;
        }).toList();

        // SingleChildScrollView agar seluruh halaman bisa discroll
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: nama toko, icon keranjang, dan pencarian
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.memory, size: 22, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BengkelKOM-Ridho',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                Text(
                                  'Rakit & upgrade PC impianmu',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Stack icon keranjang dengan Positioned badge jumlah item
                        SizedBox(
                          width: 46,
                          height: 46,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.white),
                                ),
                              ),
                              if (cart.totalItems > 0)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${cart.totalItems}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Container pencarian
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // TextField pencarian, setState mengubah searchQuery
                      child: TextField(
                        cursorColor: AppColors.red,
                        style: const TextStyle(color: AppColors.textPrimary),
                        onChanged: (value) =>
                            setState(() => searchQuery = value.toLowerCase()),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cari produk atau merek',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.search, size: 22, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Banner promo, Stack menumpuk dekorasi di belakang teks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -40,
                        right: -30,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.redDark,
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        right: 50,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(55),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 28,
                        top: 0,
                        bottom: 0,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.memory, size: 60, color: Colors.white),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PROMO SPESIAL',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Upgrade PC Lebih Hemat',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Diskon hingga 30% untuk SSD & RAM pilihan',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Kategori: tap membuka halaman kategori dengan Navigator.push
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              // scrollDirection horizontal agar kategori bisa digeser
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (final category in categoryList) _buildCategoryTile(category),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Judul daftar produk dan jumlah hasil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Produk Pilihan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      '${visibleProducts.length} produk',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Filter pilihan kategori
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        onPressed: () =>
                            setState(() => selectedCategory = category.name),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Pesan jika hasil pencarian kosong
                    if (visibleProducts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 40),
                        child: Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ProductGrid(products: visibleProducts),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Widget kategori: kotak icon dan label, membuka CategoryPage
  Widget _buildCategoryTile(Category category) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 84,
        height: 92,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryPage(category: category),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          // Column menyusun icon dan label secara vertikal
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, size: 22, color: AppColors.red),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}