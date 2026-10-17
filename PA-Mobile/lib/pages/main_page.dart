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
  int currentTab = 0; // 0 Beranda, 1 Keranjang, 2 Profil
  int? lastTotal;

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
      page = CartPage(onCheckout: checkout);
    } else {
      page = const ProfilePage();
    }

    final bool showNavBar = lastTotal == null;

    return PopScope(
      canPop: lastTotal == null && currentTab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
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

            // Floating Navigation Dock
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
                          _buildDockItem(
                            index: 0,
                            icon: Icons.storefront_outlined,
                            activeIcon: Icons.storefront_rounded,
                            label: 'Beranda',
                            activeColor: AppColors.accent,
                          ),
                          _buildDockItem(
                            index: 1,
                            icon: Icons.shopping_bag_outlined,
                            activeIcon: Icons.shopping_bag_rounded,
                            label: 'Keranjang',
                            activeColor: AppColors.accentYellow,
                            isCart: true,
                          ),
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

  Widget _buildDockItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    bool isCart = false,
  }) {
    final bool isActive = currentTab == index;
    final int cartCount =
        context.select<CartProvider, int>((cart) => cart.totalItems);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            currentTab = index;
            lastTotal = null;
          });
        },
        child: SizedBox(
          height: 64,
          child: isActive
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
                        child: Icon(activeIcon, size: 22, color: Colors.white),
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
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(icon, size: 22, color: const Color(0xFF64748B)),
                        if (isCart && cartCount > 0)
                          Positioned(
                            top: -4,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
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