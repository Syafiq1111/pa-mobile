import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

// Halaman kategori produk dengan fitur filter dan pengurutan.
class CategoryPage extends StatefulWidget {
  final Category category;
  final VoidCallback? onBack;

  const CategoryPage({
    super.key,
    required this.category,
    this.onBack,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Menyimpan merek, metode pengurutan, dan rentang harga yang dipilih.
  String selectedBrand = 'Semua';
  int sortMode = 0; // 0: Terlaris, 1: Harga Terendah, 2: Harga Tertinggi, 3: Rating Tertinggi
  int? minPrice;
  int? maxPrice;

  // Memilih warna sesuai mode terang atau gelap.
  Color _c(Color light, Color dark) => context.isDarkMode ? dark : light;

  // Warna teks dan ikon di atas latar berwarna (primary / accent).
  Color get _onColor =>
      context.isDarkMode ? AppColorsDark.background : Colors.white;

  // Mengubah kode pengurutan menjadi teks yang ditampilkan pada antarmuka.
  String _getSortLabel(int mode) {
    switch (mode) {
      case 1:
        return 'Harga Terendah';
      case 2:
        return 'Harga Tertinggi';
      case 3:
        return 'Rating Tertinggi';
      case 0:
      default:
        return 'Terlaris';
    }
  }

  // Menghitung jumlah filter yang sedang aktif.
  int get _activeFilterCount {
    int count = 0;

    if (selectedBrand != 'Semua') count++;
    if (sortMode != 0) count++;
    if (minPrice != null || maxPrice != null) count++;

    return count;
  }

  // Mengembalikan seluruh filter ke pengaturan awal.
  void _resetAllFilters() {
    setState(() {
      selectedBrand = 'Semua';
      sortMode = 0;
      minPrice = null;
      maxPrice = null;
    });
  }

  // Menampilkan modal untuk memilih pengurutan, merek, dan rentang harga.
  void _showFilterModal(BuildContext context, List<String> brands) {
    String tempBrand = selectedBrand;
    int tempSort = sortMode;

    // Menyiapkan input harga berdasarkan filter yang sedang digunakan.
    final minController = TextEditingController(
      text: minPrice != null ? minPrice.toString() : '',
    );

    final maxController = TextEditingController(
      text: maxPrice != null ? maxPrice.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar sebagai penanda modal dapat digeser.
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appOutlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header modal berisi judul, tombol reset, dan tombol tutup.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: context.appPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: _onColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Filter & Urutkan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: context.appTextPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Reset pilihan sementara di dalam modal.
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  tempBrand = 'Semua';
                                  tempSort = 0;
                                  minController.clear();
                                  maxController.clear();
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _c(const Color(0xFFFFF1EE), const Color(0xFF3A2420)),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _c(const Color(0xFFFFDAD2), const Color(0xFF5C3A33)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.restart_alt_rounded,
                                      size: 14,
                                      color: context.appSecondary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Reset',
                                      style: TextStyle(
                                        color: context.appSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => Navigator.pop(modalContext),
                              icon: Icon(
                                Icons.close_rounded,
                                color: context.appTextSecondary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: context.appSurfaceContainerLow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: context.appBorder,
                  ),

                  // Area pengaturan filter yang dapat digulir.
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        20 + bottomInset,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pilihan metode pengurutan produk.
                          _modalSectionHeader(
                            title: 'Urutkan Berdasarkan',
                            icon: Icons.sort_rounded,
                            iconColor: context.appAccent,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _sortOptionPill(
                                label: 'Terlaris',
                                isSelected: tempSort == 0,
                                icon: Icons.local_fire_department_rounded,
                                onTap: () => setModalState(
                                      () => tempSort = 0,
                                ),
                              ),
                              _sortOptionPill(
                                label: 'Harga Terendah',
                                isSelected: tempSort == 1,
                                icon: Icons.arrow_downward_rounded,
                                onTap: () => setModalState(
                                      () => tempSort = 1,
                                ),
                              ),
                              _sortOptionPill(
                                label: 'Harga Tertinggi',
                                isSelected: tempSort == 2,
                                icon: Icons.arrow_upward_rounded,
                                onTap: () => setModalState(
                                      () => tempSort = 2,
                                ),
                              ),
                              _sortOptionPill(
                                label: 'Rating Tertinggi',
                                isSelected: tempSort == 3,
                                icon: Icons.star_rounded,
                                onTap: () => setModalState(
                                      () => tempSort = 3,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          // Pilihan merek berdasarkan produk dalam kategori.
                          _modalSectionHeader(
                            title: 'Merek Produk',
                            icon: Icons.business_outlined,
                            iconColor: context.appPrimary,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _brandOptionPill(
                                label: 'Semua Merek',
                                isSelected: tempBrand == 'Semua',
                                onTap: () => setModalState(
                                      () => tempBrand = 'Semua',
                                ),
                              ),
                              for (final brand in brands)
                                _brandOptionPill(
                                  label: brand,
                                  isSelected: tempBrand == brand,
                                  onTap: () => setModalState(
                                        () => tempBrand = brand,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          // Input batas harga minimum dan maksimum.
                          _modalSectionHeader(
                            title: 'Rentang Harga (Rp)',
                            icon: Icons.payments_outlined,
                            iconColor: _c(const Color(0xFF2563EB), const Color(0xFF60A5FA)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _priceInputField(
                                  controller: minController,
                                  hint: 'Harga Min',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  '—',
                                  style: TextStyle(
                                    color: context.appTextMuted,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _priceInputField(
                                  controller: maxController,
                                  hint: 'Harga Maks',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Pilihan rentang harga cepat untuk mempermudah input.
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _pricePresetChip(
                                  label: '< 500 Rb',
                                  onTap: () {
                                    setModalState(() {
                                      minController.text = '';
                                      maxController.text = '500000';
                                    });
                                  },
                                ),
                                _pricePresetChip(
                                  label: '500 Rb - 2 Jt',
                                  onTap: () {
                                    setModalState(() {
                                      minController.text = '500000';
                                      maxController.text = '2000000';
                                    });
                                  },
                                ),
                                _pricePresetChip(
                                  label: '2 Jt - 5 Jt',
                                  onTap: () {
                                    setModalState(() {
                                      minController.text = '2000000';
                                      maxController.text = '5000000';
                                    });
                                  },
                                ),
                                _pricePresetChip(
                                  label: '> 5 Jt',
                                  onTap: () {
                                    setModalState(() {
                                      minController.text = '5000000';
                                      maxController.text = '';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol untuk menerapkan pilihan filter ke halaman kategori.
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      14,
                      20,
                      16 + MediaQuery.of(context).padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: context.appSurface,
                      border: Border(
                        top: BorderSide(color: context.appBorder),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Mengubah input harga menjadi angka sebelum disimpan.
                          final parsedMin = int.tryParse(
                            minController.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            ),
                          );

                          final parsedMax = int.tryParse(
                            maxController.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            ),
                          );

                          // Menyimpan filter yang dipilih pengguna.
                          setState(() {
                            selectedBrand = tempBrand;
                            sortMode = tempSort;
                            minPrice = parsedMin;
                            maxPrice = parsedMax;
                          });

                          Navigator.pop(modalContext);
                        },
                        icon: Icon(
                          Icons.check_rounded,
                          color: _onColor,
                          size: 20,
                        ),
                        label: Text(
                          'Terapkan Filter',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _onColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appPrimary,
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
            );
          },
        );
      },
    );
  }

  // Membuat judul bagian filter dengan ikon dan warna yang dapat disesuaikan.
  Widget _modalSectionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: context.appTextPrimary,
          ),
        ),
      ],
    );
  }

  // Membuat tombol pilihan metode pengurutan dengan penanda pilihan aktif.
  Widget _sortOptionPill({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.appAccent : context.appSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? context.appAccent
                : context.appBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? _onColor
                  : context.appTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: isSelected
                    ? _onColor
                    : context.appTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat tombol pilihan merek produk.
  Widget _brandOptionPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.appPrimary : context.appSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? context.appPrimary
                : context.appBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected
                ? FontWeight.w800
                : FontWeight.w600,
            color: isSelected
                ? _onColor
                : context.appTextPrimary,
          ),
        ),
      ),
    );
  }

  // Membuat kolom input harga dengan awalan mata uang rupiah.
  Widget _priceInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.appOutlineVariant,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _c(const Color(0xFFE6F4F1), const Color(0xFF1E3B37)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Rp',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: context.appPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.appTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: context.appTextMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat tombol rentang harga yang dapat langsung mengisi kolom harga.
  Widget _pricePresetChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: _c(const Color(0xFFFFFBEB), const Color(0xFF3A3220)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _c(const Color(0xFFFDE68A), const Color(0xFF5C4A1F)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _c(const Color(0xFFB45309), const Color(0xFFFCD34D)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Bar navigasi atas yang menampilkan tombol kembali dan nama kategori.
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.appSurface,
                border: Border(
                  bottom: BorderSide(color: context.appBorderSubtle),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack ?? () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: context.appTextPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: context.appSurfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.category.name,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: context.appTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Consumer memperbarui daftar ketika data pada CartProvider berubah.
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  // Mengambil produk yang termasuk dalam kategori saat ini.
                  final categoryProducts = cart.products.where((product) {
                    return product.category == widget.category.name;
                  }).toList();

                  // Mengumpulkan merek unik untuk ditampilkan pada pilihan filter.
                  final brands = categoryProducts
                      .map((product) => product.brand)
                      .toSet()
                      .toList()
                    ..sort();

                  // Menyaring produk berdasarkan merek dan rentang harga.
                  final visibleProducts = categoryProducts.where((product) {
                    if (selectedBrand != 'Semua' &&
                        product.brand != selectedBrand) {
                      return false;
                    }

                    if (minPrice != null && product.price < minPrice!) {
                      return false;
                    }

                    if (maxPrice != null && product.price > maxPrice!) {
                      return false;
                    }

                    return true;
                  }).toList();

                  // Mengurutkan produk sesuai metode yang dipilih pengguna.
                  if (sortMode == 1) {
                    visibleProducts.sort(
                          (a, b) => a.price.compareTo(b.price),
                    );
                  } else if (sortMode == 2) {
                    visibleProducts.sort(
                          (a, b) => b.price.compareTo(a.price),
                    );
                  } else if (sortMode == 3) {
                    visibleProducts.sort(
                          (a, b) => b.rating.compareTo(a.rating),
                    );
                  } else {
                    visibleProducts.sort(
                          (a, b) => b.sold.compareTo(a.sold),
                    );
                  }

                  // Menentukan apakah terdapat filter selain pengaturan awal.
                  final bool hasActiveFilter = _activeFilterCount > 0;

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Menampilkan jumlah produk dan tombol pengaturan filter.
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            border: Border(
                              bottom: BorderSide(
                                color: context.appBorderSubtle,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${visibleProducts.length} Produk ditemukan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: context.appTextSecondary,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => _showFilterModal(
                                  context,
                                  brands,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasActiveFilter
                                        ? context.appPrimary
                                        : context.appSurface,
                                    border: Border.all(
                                      color: hasActiveFilter
                                          ? context.appPrimary
                                          : context.appPrimary.withValues(
                                        alpha: 0.35,
                                      ),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.tune_rounded,
                                        size: 16,
                                        color: hasActiveFilter
                                            ? _onColor
                                            : context.appPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Filter & Urutkan',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: hasActiveFilter
                                              ? _onColor
                                              : context.appPrimary,
                                        ),
                                      ),

                                      // Menampilkan jumlah filter yang sedang aktif.
                                      if (hasActiveFilter) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: context.appAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 18,
                                            minHeight: 18,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$_activeFilterCount',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                color: _onColor,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Menampilkan chip filter agar pilihan dapat dihapus satu per satu.
                      if (hasActiveFilter)
                        SliverToBoxAdapter(
                          child: Container(
                            color: context.appSurface,
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              4,
                              16,
                              12,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  // Chip untuk metode pengurutan yang aktif.
                                  if (sortMode != 0)
                                    _activeFilterPill(
                                      label: _getSortLabel(sortMode),
                                      bgColor: _c(const Color(0xFFFFF7ED), const Color(0xFF3A2A1A)),
                                      borderColor: _c(const Color(0xFFFED7AA), const Color(0xFF5C4020)),
                                      textColor: _c(const Color(0xFFC2410C), const Color(0xFFFDBA74)),
                                      icon: Icons.sort_rounded,
                                      onRemove: () {
                                        setState(() => sortMode = 0);
                                      },
                                    ),

                                  // Chip untuk merek yang sedang dipilih.
                                  if (selectedBrand != 'Semua')
                                    _activeFilterPill(
                                      label: selectedBrand,
                                      bgColor: _c(const Color(0xFFE6F4F1), const Color(0xFF1E3B37)),
                                      borderColor: _c(const Color(0xFF80CBC4), const Color(0xFF2E6B63)),
                                      textColor: context.appPrimary,
                                      icon: Icons.verified_outlined,
                                      onRemove: () {
                                        setState(() {
                                          selectedBrand = 'Semua';
                                        });
                                      },
                                    ),

                                  // Chip untuk rentang harga yang sedang diterapkan.
                                  if (minPrice != null || maxPrice != null)
                                    _activeFilterPill(
                                      label: _formatActivePrice(),
                                      bgColor: _c(const Color(0xFFEFF6FF), const Color(0xFF1A2A3E)),
                                      borderColor: _c(const Color(0xFFBFDBFE), const Color(0xFF2C4A6E)),
                                      textColor: _c(const Color(0xFF1D4ED8), const Color(0xFF93C5FD)),
                                      icon: Icons.payments_outlined,
                                      onRemove: () {
                                        setState(() {
                                          minPrice = null;
                                          maxPrice = null;
                                        });
                                      },
                                    ),

                                  // Menghapus seluruh filter sekaligus.
                                  InkWell(
                                    onTap: _resetAllFilters,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _c(const Color(0xFFFFF1EE), const Color(0xFF3A2420)),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _c(const Color(0xFFFFDAD2), const Color(0xFF5C3A33)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close_rounded,
                                            size: 12,
                                            color: context.appSecondary,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'Hapus Semua',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: context.appSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Menampilkan indikator saat data produk sedang dimuat.
                      if (cart.isLoading)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: context.appPrimary,
                              ),
                            ),
                          ),
                        )

                      // Menampilkan pesan ketika tidak ada produk yang sesuai filter.
                      else if (visibleProducts.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      color: context.appSurfaceContainerLow,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: context.appBorder,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.search_off_rounded,
                                      size: 34,
                                      color: context.appTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Tidak ada produk yang cocok',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: context.appTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Coba sesuaikan atau reset filter Anda',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.appTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Tombol untuk mengembalikan filter ke pengaturan awal.
                                  ElevatedButton.icon(
                                    onPressed: _resetAllFilters,
                                    icon: const Icon(
                                      Icons.refresh_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('Reset Filter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.appPrimary,
                                      foregroundColor: _onColor,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )

                      // Menampilkan produk dalam bentuk grid ketika data tersedia.
                      else
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            14,
                            16,
                            32 + MediaQuery.of(context).padding.bottom,
                          ),
                          sliver: SliverProductGrid(
                            products: visibleProducts,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menyusun teks rentang harga untuk ditampilkan pada chip filter aktif.
  String _formatActivePrice() {
    if (minPrice != null && maxPrice != null) {
      return '${formatRupiah(minPrice!)} - ${formatRupiah(maxPrice!)}';
    } else if (minPrice != null) {
      return '≥ ${formatRupiah(minPrice!)}';
    } else if (maxPrice != null) {
      return '≤ ${formatRupiah(maxPrice!)}';
    }

    return '';
  }

  // Membuat chip filter aktif dengan warna, ikon, dan tombol hapus yang dinamis.
  Widget _activeFilterPill({
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(width: 5),

          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}