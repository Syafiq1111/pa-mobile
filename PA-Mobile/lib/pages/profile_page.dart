import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/pages/address_page.dart';
import 'package:pa_mobile/pages/favorite_page.dart';
import 'package:pa_mobile/pages/order_history_page.dart';
import 'package:pa_mobile/pages/store_chat_page.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/providers/favorite_provider.dart';
import 'package:pa_mobile/providers/theme_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _info(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _chat(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const StoreChatPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final address = context.watch<AddressProvider>();
    final favorite = context.watch<FavoriteProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'pengguna@bengkelkom.id';
    final displayName = user?.displayName?.trim() ?? '';
    final name = displayName.isEmpty ? email.split('@').first : displayName;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panel(context, Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Text(name.isEmpty ? 'U' : name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                            color: context.appTextPrimary)),
                    const SizedBox(height: 4),
                    Text(email, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: context.appTextSecondary)),
                    const SizedBox(height: 4),
                    Text('Member Terverifikasi',
                        style: TextStyle(fontSize: 11, color: context.appPrimary)),
                  ],
                )),
                IconButton(
                  tooltip: context.isDarkMode ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
                  onPressed: theme.toggleTheme,
                  icon: Icon(context.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: context.appPrimary),
                ),
              ]),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Icon(Icons.stars_rounded, color: colors.onSecondaryContainer),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Gold Member • BengkelKOM Priority Club\nGratis diagnosa & diskon sparepart 10%',
                      style: TextStyle(fontSize: 11, height: 1.5, color: colors.onSecondaryContainer))),
                ]),
              ),
            ],
          )),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _stat(context, Icons.shopping_bag_outlined,
                '${cart.orders.length}', 'Total Pesanan', '${cart.totalItems} item di keranjang')),
            const SizedBox(width: 12),
            Expanded(child: _stat(context, Icons.toll_rounded,
                '15.400', 'Poin BengkelRidho', 'Hemat Rp15.400')),
          ]),
          const SizedBox(height: 20),
          _heading(context, 'Tampilan'),
          _panel(context, SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text('Mode gelap', style: TextStyle(color: context.appTextPrimary)),
            subtitle: Text(context.isDarkMode ? 'Night mode aktif' : 'Light mode aktif',
                style: TextStyle(color: context.appTextSecondary)),
            secondary: Icon(context.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: context.appPrimary),
            value: context.isDarkMode,
            onChanged: (value) => theme.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          )),
          const SizedBox(height: 20),
          _heading(context, 'Layanan Cepat'),
          _panel(context, LayoutBuilder(builder: (context, constraints) {
            final width = (constraints.maxWidth - 12) / 2;
            return Wrap(spacing: 12, runSpacing: 16, children: [
              SizedBox(width: width, child: _quickAction(context,
                  icon: Icons.build_circle_rounded, label: 'Status Servis',
                  onTap: () => _info(context, 'Status servis: Tidak ada unit dalam antrean.'))),
              SizedBox(width: width, child: _quickAction(context,
                  icon: Icons.receipt_long_rounded, label: 'Nota Digital',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const OrderHistoryPage())))),
              SizedBox(width: width, child: _quickAction(context,
                  icon: Icons.pin_drop_rounded, label: 'Alamat Toko',
                  onTap: () => _info(context, 'Jl. P. Antasari No. 18, Samarinda Ulu'))),
              SizedBox(width: width, child: _quickAction(context,
                  icon: Icons.verified_user_rounded, label: 'Cek Garansi',
                  onTap: () => _info(context, 'Semua produk bergaransi resmi 1 tahun.'))),
            ]);
          })),
          const SizedBox(height: 20),
          _heading(context, 'Preferensi & Akun'),
          _panel(context, Column(children: [
            _profileMenuItem(context,
                icon: Icons.favorite_border_rounded,
                title: 'Produk Favorit',
                subtitle: favorite.count == 0 ? 'Belum ada produk favorit' : '${favorite.count} produk tersimpan',
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => const FavoritePage()))),
            const Divider(),
            _profileMenuItem(context,
                icon: Icons.location_on_outlined,
                title: 'Alamat Pengiriman & Titik Antar',
                subtitle: address.addresses.isEmpty ? 'Belum ada alamat tersimpan' : '${address.addresses.length} alamat tersimpan',
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => const AddressPage()))),
            const Divider(),
            _profileMenuItem(context,
                icon: Icons.history_edu_rounded,
                title: 'Riwayat Pembelian & Nota Digital',
                subtitle: cart.orders.isEmpty ? 'Belum ada pesanan tersimpan' : '${cart.orders.length} pesanan berhasil',
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => const OrderHistoryPage()))),
            const Divider(),
            _profileMenuItem(context,
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat Toko', subtitle: 'Percakapan dengan BengkelKOM',
                onTap: () => _chat(context)),
            const Divider(),
            _profileMenuItem(context,
                icon: Icons.engineering_rounded,
                title: 'Konsultasi Teknisi BengkelKOM', subtitle: 'Tanya rakit PC, upgrade RAM/SSD',
                onTap: () => _chat(context)),
            const Divider(),
            _profileMenuItem(context,
                icon: Icons.support_agent_rounded,
                title: 'Pusat Bantuan', subtitle: 'Buka chat layanan pelanggan',
                onTap: () => _chat(context)),
          ])),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
              } on FirebaseAuthException catch (error) {
                if (!context.mounted) return;
                _info(context, 'Gagal keluar (${error.code}). Coba lagi.');
              }
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar dari Akun'),
            style: FilledButton.styleFrom(backgroundColor: colors.errorContainer,
                foregroundColor: colors.onErrorContainer,
                padding: const EdgeInsets.symmetric(vertical: 14)),
          )),
          const SizedBox(height: 16),
          Center(child: Text('© 2026 BengkelKOM. Jl. P. Antasari, Samarinda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: context.appOutline))),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
        color: context.appTextPrimary)),
  );

  Widget _panel(BuildContext context, Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appBorderSubtle)),
    child: child,
  );

  Widget _stat(BuildContext context, IconData icon, String value, String label, String note) =>
      _panel(context, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: context.appPrimary),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
            color: context.appTextPrimary)),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: context.appTextPrimary)),
        const SizedBox(height: 4),
        Text(note, style: TextStyle(fontSize: 10, color: context.appTextSecondary)),
      ]));

  Widget _quickAction(BuildContext context, {
    required IconData icon, required String label, required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, color: context.appPrimary),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w600, color: context.appTextPrimary))),
        ])),
  );

  Widget _profileMenuItem(BuildContext context, {
    required IconData icon, required String title, required String subtitle,
    required VoidCallback onTap,
  }) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: context.appPrimary),
    title: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
        color: context.appTextPrimary)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: context.appTextSecondary)),
    trailing: Icon(Icons.chevron_right_rounded, color: context.appOutline),
    onTap: onTap,
  );
}