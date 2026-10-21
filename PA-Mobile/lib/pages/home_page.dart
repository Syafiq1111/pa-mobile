import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/pages/notification_page.dart';
import 'package:pa_mobile/pages/store_chat_page.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/app_logo.dart';
import 'package:pa_mobile/widgets/filter_chip_button.dart';
import 'package:pa_mobile/widgets/product_grid.dart';

const String _promoBannerAsset = 'assets/images/card.png';
const String _promoCircleAsset = 'assets/images/roundedcard.png';

class MyHomePage extends StatefulWidget {
  final void Function(Category category) onCategoryTap;

  const MyHomePage({super.key, required this.onCategoryTap});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchQuery = '';
  String selectedCategory = 'Semua';
  bool hasUnreadNotification = true; // titik merah pada ikon lonceng

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

        return CustomScrollView(
          key: PageStorageKey<String>('home_scroll'),
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            SliverToBoxAdapter(child: _buildCategoriesSection()),
            SliverToBoxAdapter(child: _buildDigitalWallet(context)),
            SliverToBoxAdapter(child: _buildDealsHeader(visibleProducts.length)),

            if (cart.isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: context.appPrimary),
                  ),
                ),
              )
            else if (cart.errorMessage != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Center(
                    child: Text(
                      cart.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.appDanger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else if (visibleProducts.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 54, color: context.appOutline.withValues(alpha: 0.5)),
                          SizedBox(height: 10),
                          Text(
                            'Produk tidak ditemukan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.appTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverProductGrid(products: visibleProducts),
                ),

            SliverToBoxAdapter(child: _buildGuaranteeBanner()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 14, bottom: 6),
                child: Center(
                  child: Text(
                    '© 2026 BengkelKOM. Jl. P. Antasari, Samarinda.',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.appOutline,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 160)),
          ],
        );
      },
    );
  }

  // Header Brand & Delivery Location
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Logo dari assets/images/logo.png (ikon cadangan jika gagal dimuat)
                  AppLogo(size: 34, radius: 10),

                  SizedBox(width: 10),
                  Text.rich(
                    TextSpan(
                      text: 'Bengkel',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: context.appPrimary,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'KOM',
                          style: TextStyle(
                            color: context.appPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      tooltip: 'Chat toko',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(width: 36, height: 36),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => StoreChatPage()),
                      ),
                      icon: Icon(Icons.chat_bubble_outline_rounded, size: 20, color: context.appPrimary),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Tombol notifikasi: membuka halaman notifikasi
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          tooltip: 'Notifikasi',
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tightFor(width: 36, height: 36),
                          style: IconButton.styleFrom(
                            backgroundColor:
                            context.appSurfaceContainerHigh.withValues(alpha: 0.8),
                          ),
                          onPressed: () {
                            setState(() => hasUnreadNotification = false);
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => NotificationPage()),
                            );
                          },
                          icon: Icon(Icons.notifications_none_rounded,
                              size: 20, color: context.appTextPrimary),
                        ),
                      ),
                      // Titik merah hilang setelah notifikasi dibuka
                      if (hasUnreadNotification)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IgnorePointer(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: context.appSecondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),

          // Location Strip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.appSurfaceContainerLow.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: context.appPrimaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on, size: 16, color: context.appPrimary),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Samarinda',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: context.appTextPrimary,
                        ),
                      ),
                      Text(
                        'BTM Layout, Antasari 75119',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.appTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Rounded Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: context.appBorder, width: 1.2),
        ),
        child: TextField(
          style: TextStyle(fontSize: 13, color: context.appTextPrimary),
          // Teks dan placeholder rata tengah secara vertikal, sejajar dengan ikon
          textAlignVertical: TextAlignVertical.center,
          onChanged: (value) => setState(() => searchQuery = value.trim().toLowerCase()),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Cari komponen, sparepart, laptop...',
            hintStyle: TextStyle(fontSize: 13, color: context.appOutline),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
            prefixIconConstraints: BoxConstraints(minWidth: 46, minHeight: 44),
            suffixIconConstraints: BoxConstraints(minHeight: 44),
            prefixIcon: Icon(Icons.search_rounded, size: 22, color: context.appOutline),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 18,
                  width: 1,
                  color: context.appBorder,
                ),
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 44, minHeight: 44),
                  icon: Icon(Icons.mic_none_rounded, size: 18, color: context.appPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Promo Hero Banner (latar foto dari assets lokal)
  Widget _buildPromoBanner() {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: Color(0xFFDAF5E4), // warna cadangan jika foto gagal dimuat
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFFC3ECCF), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Foto latar
            Positioned.fill(
              child: Image.asset(
                'assets/images/promoBanner.png',
                fit: BoxFit.cover,
                cacheWidth: (screenWidth * pixelRatio).round(),
                errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Promo Weekend',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.appTextSecondary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '25% OFF',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: context.appTextPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '*Untuk Komponen & Servis',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: context.appTextPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: context.appPrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Klaim Promo',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kategori Hardware Grid / Row with Squircle Cards
  Widget _buildCategoriesSection() {
    final colors = [
      context.appPrimary,
      context.appTertiaryContainer,
      context.appSecondaryContainer,
      Color(0xFF6D3DA3),
      context.appAccentYellow,
      context.appPrimaryContainer,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: context.appTextPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 94,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: categoryList.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categoryList[index];
              final catColor = colors[index % colors.length];

              return InkWell(
                onTap: () => widget.onCategoryTap(cat),
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: catColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(cat.icon, size: 26, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: context.appTextPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Deals Header & Filter Chips
  Widget _buildDigitalWallet(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colors.primary, colors.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppStyle.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.account_balance_wallet_rounded, color: colors.onPrimary),
            SizedBox(width: 8),
            Expanded(child: Text('Dompet Digital', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.onPrimary))),
            Text('Saldo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: colors.onPrimary.withValues(alpha: .8))),
          ]),
          SizedBox(height: 12),
          Text('Saldo BengkelPay', style: TextStyle(fontSize: 11, color: colors.onPrimary.withValues(alpha: .8))),
          Text('Rp250.000', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: colors.onPrimary)),
          SizedBox(height: 14),
          Container(height: 1, color: colors.onPrimary.withValues(alpha: .2)),
          SizedBox(height: 10),
          Row(children: [
            Expanded(child: _walletAction(context, Icons.add_rounded, 'Top up', () => _walletMessage(context, 'Top up BengkelPay'))),
            Expanded(child: _walletAction(context, Icons.receipt_long_rounded, 'Riwayat', () => _walletMessage(context, 'Belum ada transaksi dompet.'))),
            Expanded(child: _walletAction(context, Icons.credit_score_rounded, 'PayLater', () => _showPayLater(context))),
          ]),
        ]),
      ),
    );
  }

  Widget _walletAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final foreground = Theme.of(context).colorScheme.onPrimary;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(children: [Icon(icon, color: foreground, size: 21), SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: foreground))]),
    ));
  }

  void _walletMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPayLater(BuildContext context) {
    showModalBottomSheet<void>(context: context, backgroundColor: context.appSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BengkelPayLater', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.appTextPrimary)),
          SizedBox(height: 12),
          Text('Limit paylater tersedia: Rp2.000.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.appTextPrimary)),
          SizedBox(height: 6),
          Text('Cicilan 0% hingga 3 bulan.', style: TextStyle(fontSize: 12, height: 1.5, color: context.appTextSecondary)),
          SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(sheetContext), child: Text('Mengerti'))),
        ]),
      ),
    );
  }

  // Deals Header & Filter Chips
  Widget _buildDealsHeader(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Deals Terlaris',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: context.appTextPrimary,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.appSecondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            size: 14, color: context.appSecondary),
                        SizedBox(width: 2),
                        Text(
                          'Flash Sale',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.appSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '$count produk',
                style: TextStyle(fontSize: 12, color: context.appTextSecondary),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChipButton(
                label: 'Semua',
                selected: selectedCategory == 'Semua',
                onPressed: () => setState(() => selectedCategory = 'Semua'),
              ),
              for (final cat in categoryList)
                FilterChipButton(
                  label: cat.name,
                  selected: selectedCategory == cat.name,
                  onPressed: () => setState(() => selectedCategory = cat.name),
                ),
            ],
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }

  // Garansi Servis Samarinda Micro-Banner
  Widget _buildGuaranteeBanner() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appSurfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.appPrimaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.verified_user_rounded,
                  size: 24, color: context.appPrimary),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Garansi Servis Samarinda',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.appTextPrimary,
                    ),
                  ),
                  Text(
                    'Teknisi tersertifikasi, gratis konsultasi & cek fisik unit.',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.appTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: context.appOutline),
          ],
        ),
      ),
    );
  }
}