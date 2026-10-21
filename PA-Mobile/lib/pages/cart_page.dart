
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/providers/cart_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/cart_product_card.dart';

// Halaman keranjang untuk mengelola produk dan melanjutkan proses checkout.
class CartPage extends StatefulWidget {
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.onCheckout,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Menyimpan kata kunci pencarian produk di dalam keranjang.
  String searchQuery = '';

  // Menyediakan kode voucher yang ditampilkan pada kolom voucher.
  final TextEditingController voucherController =
  TextEditingController(text: 'BENGKELHEMAT100');

  @override
  void dispose() {
    // Melepaskan controller ketika halaman tidak lagi digunakan.
    voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Consumer memperbarui tampilan ketika data keranjang berubah.
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Mengambil data alamat utama pengguna dari AddressProvider.
        final addressProvider = context.watch<AddressProvider>();
        final mainAddress = addressProvider.mainAddress;

        // Menampilkan produk yang nama atau mereknya sesuai pencarian.
        final cartItems = cart.cartProducts.where((product) {
          return product.name.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);
        }).toList();

        return Column(
          children: [
            // Area utama berisi informasi keranjang dan detail pembayaran.
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14),

                      // Header keranjang dan informasi jaminan toko.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              BengkelKomLogo(
                                size: 32,
                                borderRadius: 10,
                                showShadow: false,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Keranjang Belanja',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: context.appTextPrimary,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: context.appPrimaryContainer,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '${cart.totalItems} item siap dikirim dari Samarinda',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.appTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Label yang menunjukkan identitas toko resmi.
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: context.appPrimaryFixed.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: context.appPrimary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Toko Resmi SMD',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: context.appPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14),

                      // Kolom pencarian untuk menyaring produk di keranjang.
                      Container(
                        decoration: BoxDecoration(
                          color: context.appSurface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: AppStyle.softShadow,
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 13,
                            color: context.appTextPrimary,
                          ),
                          // Teks dan placeholder rata tengah secara vertikal, sejajar dengan ikon
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.trim().toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Cari item di keranjang...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: context.appOutline,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 46,
                              minHeight: 44,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: context.appOutline,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Menampilkan daftar produk atau pesan kondisi keranjang.
                      if (cartItems.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: context.appSurfaceContainerLow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 34,
                                    color: context.appOutline,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  cart.cartProducts.isEmpty
                                      ? 'Keranjang Anda masih kosong'
                                      : 'Produk tidak ditemukan di keranjang',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.appTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,

                          // Memberikan jarak antarproduk pada daftar keranjang.
                          separatorBuilder: (context, index) =>
                          SizedBox(height: 12),

                          // Membuat kartu produk beserta kontrol jumlah dan hapus.
                          itemBuilder: (context, index) {
                            final product = cartItems[index];

                            return CartProductCard(
                              key: ValueKey(product.id),
                              product: product,
                              quantity: cart.cartQuantities[product.id] ?? 0,
                              maxQuantity: product.stock,

                              // Memperbarui jumlah produk melalui CartProvider.
                              onQuantityChanged: (value) => context
                                  .read<CartProvider>()
                                  .changeQuantity(product, value),

                              // Menghapus produk yang dipilih dari keranjang.
                              onRemove: () => context
                                  .read<CartProvider>()
                                  .removeFromCart(product),
                            );
                          },
                        ),

                      // Informasi tambahan hanya ditampilkan jika keranjang berisi produk.
                      if (cart.cartProducts.isNotEmpty) ...[
                        SizedBox(height: 16),

                        // Kartu informasi garansi dan pemeriksaan produk.
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: context.appPrimaryFixed.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: context.appPrimaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.verified_user_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Garansi Resmi Toko BengkelKOM',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: context.appPrimaryDark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Semua hardware & peripheral diuji fungsi dan kelistrikannya oleh teknisi sebelum dikirim via kurir instan.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: context.appTextSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14),

                        // Bagian voucher yang menampilkan kode diskon toko.
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppStyle.softShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.confirmation_number_rounded,
                                        size: 18,
                                        color: context.appSecondary,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Voucher Diskon Toko',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: context.appTextPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '1 Dipakai',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: context.appSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.appSurfaceContainerLow,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.sell_outlined,
                                            size: 16,
                                            color: context.appOutline,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              controller: voucherController,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: context.appPrimary,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Label status voucher yang ditampilkan pada antarmuka.
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.appSecondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.appSecondaryContainer
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Tersimpan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14),

                        // Menampilkan informasi pengiriman dan alamat tujuan.
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppStyle.softShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: context.appTertiaryContainer.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.two_wheeler_rounded,
                                  size: 20,
                                  color: context.appTertiary,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Instan Samarinda Kota (1-2 Jam)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: context.appTextPrimary,
                                      ),
                                    ),

                                    // Menggunakan alamat utama jika tersedia.
                                    Text(
                                      mainAddress == null
                                          ? 'Kirim ke: Samarinda (Atur di Profil)'
                                          : 'Kirim ke: ${mainAddress.name} - ${mainAddress.detail}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: context.appTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.appPrimaryFixed.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'GRATIS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: context.appPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14),

                        // Ringkasan biaya produk, pengiriman, dan asuransi.
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppStyle.softShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ringkasan Pembayaran',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: context.appTextPrimary,
                                ),
                              ),
                              SizedBox(height: 10),

                              // Menampilkan subtotal seluruh produk dalam keranjang.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal Produk (${cart.totalItems} item)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.appTextSecondary,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(cart.grandTotal),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: context.appTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              // Menampilkan ongkos kirim normal dan biaya setelah diskon.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Ongkos Kirim Kurir Bengkel',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: context.appTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp 15.000',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.appOutline,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Rp 0',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: context.appPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              // Menampilkan biaya asuransi perangkat.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Biaya Asuransi Perangkat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.appTextSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Gratis',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: context.appPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  color: context.appSurfaceContainerHigh,
                                ),
                              ),

                              // Menampilkan total pembayaran yang harus dibayar.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Pembayaran',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: context.appTextPrimary,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(cart.grandTotal),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: context.appPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Memberikan ruang agar konten tidak tertutup bilah checkout.
                      SizedBox(
                        height: 170 + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bilah checkout tetap terlihat di bagian bawah halaman.
            if (cart.grandTotal > 0)
              Container(
                margin: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  88 + MediaQuery.of(context).padding.bottom,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Menampilkan total tagihan pada bagian bawah.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Tagihan',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.appTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatRupiah(cart.grandTotal),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: context.appPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14),

                    // Tombol checkout dinonaktifkan selama transaksi diproses.
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: !cart.isCheckingOut
                              ? widget.onCheckout
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appPrimary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: context.appPrimary.withValues(
                              alpha: 0.35,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          // Menampilkan indikator proses atau jumlah item checkout.
                          child: cart.isCheckingOut
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_rounded,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Checkout (${cart.totalItems})',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
  