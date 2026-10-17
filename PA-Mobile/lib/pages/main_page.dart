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

// MainPage menyimpan state lokal: tab aktif, kategori terbuka, dan hasil checkout.
// Hanya SATU halaman yang dibangun pada satu waktu, jadi saat kategori dibuka
// Beranda ditutup (dispose) dan tidak ikut dirender di belakang.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentTab = 0; // 0 Beranda, 1 Keranjang, 2 Profil
  int? lastTotal; // total checkout; null = TotalPage tidak ditampilkan
  Category? selectedCategory; // null = Beranda, isi = halaman kategori

  // Checkout memakai transaksi Firestore: stok database berkurang di sini
  Future<void> checkout() async {
    final cart = context.read<CartProvider>();
    final address = context.read<AddressProvider>().mainAddress;
    final total = cart.grandTotal;

    final error = await cart.checkout(
      address: address == null
          ? 'Alamat belum diisi'
          : '${address.name} (${address.phone}) - ${address.detail}',
    );
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => lastTotal = total);
  }

  @override
  Widget build(BuildContext context) {
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
      page = selectedCategory == null
          ? MyHomePage(
        onCategoryTap: (category) =>
            setState(() => selectedCategory = category),
      )
          : CategoryPage(
        key: ValueKey(selectedCategory!.name),
        category: selectedCategory!,
        onBack: () => setState(() => selectedCategory = null),
      );
    } else if (currentTab == 1) {
      page = CartPage(onCheckout: checkout);
    } else {
      page = const ProfilePage();
    }

    // Tombol back Android: tutup kategori / hasil checkout / kembali ke Beranda
    return PopScope(
      canPop: lastTotal == null && currentTab == 0 && selectedCategory == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          if (lastTotal != null) {
            lastTotal = null;
            currentTab = 0;
          } else if (selectedCategory != null) {
            selectedCategory = null;
          } else {
            currentTab = 0;
          }
        });
      },
      child: Scaffold(
        body: SafeArea(child: page),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentTab,
          onDestinationSelected: (index) {
            setState(() {
              currentTab = index;
              lastTotal = null;
              selectedCategory = null;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: _CartNavIcon(selected: false),
              selectedIcon: _CartNavIcon(selected: true),
              label: 'Keranjang',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// Icon keranjang dengan jumlah item; hanya bagian ini yang dibangun ulang
class _CartNavIcon extends StatelessWidget {
  final bool selected;

  const _CartNavIcon({required this.selected});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((cart) => cart.totalItems);
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: Icon(selected ? Icons.shopping_bag : Icons.shopping_bag_outlined),
    );
  }
}