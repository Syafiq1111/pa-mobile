import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/category.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/pages/home_page.dart';
import 'package:pa_mobile/pages/category_page.dart';
import 'package:pa_mobile/pages/cart_page.dart';
import 'package:pa_mobile/pages/total_page.dart';
import 'package:pa_mobile/pages/profile_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Menyimpan tab aktif: 0 Beranda, 1 Keranjang, dan 2 Profil.
  int currentTab = 0;

  // Menyimpan total transaksi untuk ditampilkan setelah checkout berhasil.
  int? lastTotal;

  // Memproses checkout menggunakan data keranjang dan alamat utama pengguna.
  Future<void> checkout() async {
    final cart = context.read<CartProvider>();
    final address = context.read<AddressProvider>().mainAddress;
    final total = cart.grandTotal;

    // Mengirim data alamat ke proses checkout.
    final error = await cart.checkout(
      address: address == null
          ? 'Alamat belum diisi'
          : '${address.name} (${address.phone}) - ${address.detail}',
    );

    // Memastikan widget masih aktif sebelum memperbarui tampilan.
    if (!mounted) return;

    // Menampilkan pesan apabila checkout gagal.
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    // Menyimpan total transaksi untuk ditampilkan pada halaman konfirmasi.
    setState(() => lastTotal = total);
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    // Menentukan halaman yang ditampilkan sesuai kondisi navigasi.
    if (lastTotal != null) {
      // Menampilkan ringkasan transaksi setelah checkout berhasil.
      page = TotalPage(
        total: lastTotal!,
        onBack: () => setState(() {
          lastTotal = null;
          currentTab = 0;
        }),
      );
    } else if (currentTab == 0) {
      // Menampilkan beranda beserta navigasi menuju halaman kategori.
      page = MyHomePage(
        onCategoryTap: (category) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(category: category),
            ),
          );
        },
      );
    } else if (currentTab == 1) {
      // Menampilkan keranjang dan menyediakan aksi checkout.
      page = CartPage(onCheckout: checkout);
    } else {
      // Menampilkan informasi akun dan pengaturan profil pengguna.
      page = const ProfilePage();
    }

    // Navigation dock disembunyikan pada halaman konfirmasi transaksi.
    final bool showNavBar = lastTotal == null;

    return PopScope(
      // Mengizinkan tombol kembali sistem keluar saat berada di beranda.
      canPop: lastTotal == null && currentTab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Mengembalikan pengguna ke beranda saat tombol kembali ditekan.
        setState(() {
          if (lastTotal != null) {
            lastTotal = null;
            currentTab = 0;
          } else {
            currentTab = 0;
          }
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SafeArea(bottom: false, child: page),

            // Navigation dock mengambang untuk berpindah antartab utama.
            if (showNavBar)
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SafeArea(
                  top: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 380),
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Tombol navigasi menuju beranda.
                          _buildDockItem(
                            index: 0,
                            icon: Icons.storefront_outlined,
                            activeIcon: Icons.storefront_rounded,
                            label: 'Beranda',
                            activeColor: AppColors.accent,
                          ),

                          // Tombol keranjang dengan indikator jumlah item.
                          _buildDockItem(
                            index: 1,
                            icon: Icons.shopping_bag_outlined,
                            activeIcon: Icons.shopping_bag_rounded,
                            label: 'Keranjang',
                            activeColor: AppColors.accentYellow,
                            isCart: true,
                          ),

                          // Tombol navigasi menuju profil pengguna.
                          _buildDockItem(
                            index: 2,
                            icon: Icons.person_outline_rounded,
                            activeIcon: Icons.person_rounded,
                            label: 'Akun',
                            activeColor: const Color(0xFF7C3AED),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Membuat item navigation dock dengan ikon dan label sesuai tab.
  Widget _buildDockItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    bool isCart = false,
  }) {
    final bool isActive = currentTab == index;

    // Mengambil jumlah item keranjang agar badge diperbarui secara otomatis.
    final int cartCount =
    context.select<CartProvider, int>((cart) => cart.totalItems);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Mengubah tab aktif dan menutup tampilan konfirmasi transaksi.
          setState(() {
            currentTab = index;
            lastTotal = null;
          });
        },
        child: SizedBox(
          height: 64,
          child: isActive
          // Menampilkan ikon aktif dengan warna sesuai tab terpilih.
              ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, -6),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activeIcon,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -4),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: activeColor,
                  ),
                ),
              ),
            ],
          )
          // Menampilkan ikon standar untuk tab yang tidak aktif.
              : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),

                  // Badge jumlah item hanya muncul pada tab keranjang.
                  if (isCart && cartCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Text(
                          '$cartCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
