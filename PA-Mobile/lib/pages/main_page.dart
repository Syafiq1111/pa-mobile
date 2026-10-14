import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/pages/home_page.dart';
import 'package:pa_mobile/pages/cart_page.dart';
import 'package:pa_mobile/pages/total_page.dart';
import 'package:pa_mobile/pages/profile_page.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// MainPage tetap Stateful hanya menyimpan state lokal (tab aktif & total hasil checkout)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentTab = 0; // tab aktif (0 Beranda, 1 Keranjang, 2 Profil)
  int? lastTotal; // total checkout; null = TotalPage tidak ditampilkan

  // Checkout: context.read mengambil provider satu kali tanpa mendengarkan perubahan
  void checkout() {
    final cart = context.read<CartProvider>();
    final address = context.read<AddressProvider>().mainAddress;
    final total = cart.grandTotal;

    // Alamat utama ikut tersimpan di riwayat pembelian
    cart.checkout(
      address: address == null
          ? 'Alamat belum diisi'
          : '${address.name} (${address.phone}) - ${address.detail}',
    );
    setState(() => lastTotal = total);
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan halaman yang tampil berdasarkan state lokal
    Widget page;
    if (lastTotal != null) {
      page = TotalPage(
        total: lastTotal!,
        onBack: () => setState(() {
          lastTotal = null;
          currentTab = 0;
        }),
      );
    } else if (currentTab == 0) {
      page = const MyHomePage();
    } else if (currentTab == 1) {
      page = CartPage(onCheckout: checkout);
    } else {
      page = const ProfilePage();
    }

    // Scaffold struktur dasar halaman, dipakai bersama semua tab
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: page), // SafeArea agar tidak tertutup notch
      // NavigationBar navigasi bawah, setState mengganti tab aktif
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.red,
        selectedIndex: currentTab,
        onDestinationSelected: (index) {
          setState(() {
            currentTab = index;
            lastTotal = null;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}