import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';

// ChangeNotifier menyediakan mekanisme notifikasi perubahan state
class CartProvider extends ChangeNotifier {
  final List<Product> products = [
    Product(
      id: 'kb1',
      name: 'G512 Carbon',
      brand: 'Logitech',
      category: 'Keyboard',
      description: 'GX Blue, RGB, Full Size',
      price: 1350000,
      stock: 10,
      image: 'assets/images/keyboard_logitech_g512.png',
      rating: 4.8,
      sold: 320,
    ),
    Product(
      id: 'kb2',
      name: 'BlackWidow V3',
      brand: 'Razer',
      category: 'Keyboard',
      description: 'Green Switch, Chroma RGB',
      price: 1850000,
      stock: 6,
      image: 'assets/images/keyboard_razer_blackwidow.png',
      rating: 4.7,
      sold: 210,
    ),
    Product(
      id: 'kb3',
      name: 'K2 V2 Wireless',
      brand: 'Keychron',
      category: 'Keyboard',
      description: '75%, Hot-swap, Bluetooth',
      price: 1150000,
      stock: 8,
      image: 'assets/images/keyboard_keychron_k2.png',
      rating: 4.9,
      sold: 540,
    ),
    Product(
      id: 'kb4',
      name: 'Daxa M84',
      brand: 'Rexus',
      category: 'Keyboard',
      description: 'Red Switch, TKL, RGB',
      price: 450000,
      stock: 15,
      image: 'assets/images/keyboard_rexus_daxa.png',
      rating: 4.5,
      sold: 780,
    ),
    Product(
      id: 'ms1',
      name: 'G102 Lightsync',
      brand: 'Logitech',
      category: 'Mouse',
      description: '8000 DPI, RGB, 6 Tombol',
      price: 250000,
      stock: 20,
      image: 'assets/images/mouse_logitech_g102.png',
      rating: 4.8,
      sold: 1250,
    ),
    Product(
      id: 'ms2',
      name: 'DeathAdder V3',
      brand: 'Razer',
      category: 'Mouse',
      description: '30000 DPI, Ultra Ringan 59g',
      price: 1450000,
      stock: 5,
      image: 'assets/images/mouse_razer_deathadder.png',
      rating: 4.8,
      sold: 190,
    ),
    Product(
      id: 'ms3',
      name: 'MX Master 3S',
      brand: 'Logitech',
      category: 'Mouse',
      description: 'Wireless, 8000 DPI, Silent',
      price: 1650000,
      stock: 7,
      image: 'assets/images/mouse_logitech_mx_master.png',
      rating: 4.9,
      sold: 430,
    ),
    Product(
      id: 'ms4',
      name: 'Xierra G9',
      brand: 'Rexus',
      category: 'Mouse',
      description: 'Wireless 2.4G, 7 Tombol',
      price: 175000,
      stock: 25,
      image: 'assets/images/mouse_rexus_xierra.png',
      rating: 4.4,
      sold: 960,
    ),
    Product(
      id: 'st1',
      name: '980 NVMe 500GB',
      brand: 'Samsung',
      category: 'Storage',
      description: 'Read 3500 MB/s, M.2',
      price: 750000,
      stock: 12,
      image: 'assets/images/storage_samsung_980.png',
      rating: 4.9,
      sold: 610,
    ),
    Product(
      id: 'st2',
      name: 'Blue SN580 1TB',
      brand: 'WD',
      category: 'Storage',
      description: 'NVMe Gen4, Read 4150 MB/s',
      price: 1100000,
      stock: 9,
      image: 'assets/images/storage_wd_sn580.png',
      rating: 4.8,
      sold: 340,
    ),
    Product(
      id: 'st3',
      name: 'NV2 1TB',
      brand: 'Kingston',
      category: 'Storage',
      description: 'NVMe, Read 3500 MB/s',
      price: 950000,
      stock: 14,
      image: 'assets/images/storage_kingston_nv2.png',
      rating: 4.7,
      sold: 520,
    ),
    Product(
      id: 'st4',
      name: 'MX500 500GB',
      brand: 'Crucial',
      category: 'Storage',
      description: 'SATA SSD 2.5 Inch',
      price: 780000,
      stock: 10,
      image: 'assets/images/storage_crucial_mx500.png',
      rating: 4.8,
      sold: 280,
    ),
    Product(
      id: 'st5',
      name: 'Barracuda 2TB',
      brand: 'Seagate',
      category: 'Storage',
      description: 'HDD 7200 RPM, 3.5 Inch',
      price: 920000,
      stock: 11,
      image: 'assets/images/storage_seagate_barracuda.png',
      rating: 4.6,
      sold: 410,
    ),
    Product(
      id: 'mn1',
      name: '24MP400 24 Inch',
      brand: 'LG',
      category: 'Monitor',
      description: 'IPS Full HD, 75Hz',
      price: 1450000,
      stock: 6,
      image: 'assets/images/monitor_lg_24mp400.png',
      rating: 4.7,
      sold: 230,
    ),
    Product(
      id: 'mn2',
      name: 'Odyssey G3 24 Inch',
      brand: 'Samsung',
      category: 'Monitor',
      description: 'Full HD, 144Hz, 1ms',
      price: 2250000,
      stock: 4,
      image: 'assets/images/monitor_samsung_odyssey_g3.png',
      rating: 4.8,
      sold: 150,
    ),
    Product(
      id: 'mn3',
      name: '27G2 27 Inch',
      brand: 'AOC',
      category: 'Monitor',
      description: 'IPS, 144Hz, Frameless',
      price: 2850000,
      stock: 3,
      image: 'assets/images/monitor_aoc_27g2.png',
      rating: 4.8,
      sold: 120,
    ),
    Product(
      id: 'mn4',
      name: 'S2421HN 24 Inch',
      brand: 'Dell',
      category: 'Monitor',
      description: 'IPS Full HD, 75Hz, HDMI',
      price: 1890000,
      stock: 5,
      image: 'assets/images/monitor_dell_s2421hn.png',
      rating: 4.6,
      sold: 175,
    ),
    Product(
      id: 'hs1',
      name: 'Cloud II 7.1',
      brand: 'HyperX',
      category: 'Headset',
      description: 'Surround 7.1, Mic Detachable',
      price: 1450000,
      stock: 7,
      image: 'assets/images/headset_hyperx_cloud2.png',
      rating: 4.8,
      sold: 360,
    ),
    Product(
      id: 'hs2',
      name: 'G331 Stereo',
      brand: 'Logitech',
      category: 'Headset',
      description: 'Driver 50mm, Flip Mic',
      price: 780000,
      stock: 9,
      image: 'assets/images/headset_logitech_g331.png',
      rating: 4.6,
      sold: 290,
    ),
    Product(
      id: 'hs3',
      name: 'Kraken X 7.1',
      brand: 'Razer',
      category: 'Headset',
      description: 'Ultra Ringan 250g, 7.1',
      price: 750000,
      stock: 10,
      image: 'assets/images/headset_razer_kraken_x.png',
      rating: 4.5,
      sold: 330,
    ),
    Product(
      id: 'hs4',
      name: 'Arctis Nova 1',
      brand: 'SteelSeries',
      category: 'Headset',
      description: 'Hi-Fi Driver, Mic ClearCast',
      price: 1350000,
      stock: 5,
      image: 'assets/images/headset_steelseries_arctis.png',
      rating: 4.8,
      sold: 140,
    ),
    Product(
      id: 'rm1',
      name: 'Fury Beast 16GB DDR4',
      brand: 'Kingston',
      category: 'RAM',
      description: '3200 MHz, Heatsink',
      price: 780000,
      stock: 12,
      image: 'assets/images/ram_kingston_fury_ddr4.png',
      rating: 4.9,
      sold: 670,
    ),
    Product(
      id: 'rm2',
      name: 'Vengeance 16GB (2x8)',
      brand: 'Corsair',
      category: 'RAM',
      description: 'DDR4 3200 MHz, Dual Kit',
      price: 950000,
      stock: 8,
      image: 'assets/images/ram_corsair_vengeance.png',
      rating: 4.8,
      sold: 380,
    ),
    Product(
      id: 'rm3',
      name: 'Ripjaws V 16GB',
      brand: 'G.Skill',
      category: 'RAM',
      description: 'DDR4 3600 MHz, CL18',
      price: 920000,
      stock: 6,
      image: 'assets/images/ram_gskill_ripjaws.png',
      rating: 4.8,
      sold: 210,
    ),
    Product(
      id: 'rm4',
      name: 'Fury Beast 16GB DDR5',
      brand: 'Kingston',
      category: 'RAM',
      description: '5200 MHz, XMP 3.0',
      price: 1150000,
      stock: 9,
      image: 'assets/images/ram_kingston_fury_ddr5.png',
      rating: 4.7,
      sold: 260,
    ),
  ];

  // Map id produk -> jumlah di keranjang
  final Map<String, int> cartQuantities = {};

  // Total harga seluruh isi keranjang
  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  // Jumlah seluruh item di keranjang
  int get totalItems => cartQuantities.values.fold(0, (a, b) => a + b);

  // Daftar produk yang ada di keranjang
  List<Product> get cartProducts {
    return products.where((product) {
      return (cartQuantities[product.id] ?? 0) > 0;
    }).toList();
  }

  void addToCart(Product product) {
    if (product.stock == 0) return;

    product.stock--;
    cartQuantities[product.id] = (cartQuantities[product.id] ?? 0) + 1;
    notifyListeners();
  }

  // Mengubah jumlah produk di keranjang, stok ikut menyesuaikan
  void changeQuantity(Product product, int quantity) {
    final current = cartQuantities[product.id] ?? 0;
    final maxQuantity = current + product.stock;
    final newQuantity = quantity.clamp(1, maxQuantity);

    product.stock -= newQuantity - current;
    cartQuantities[product.id] = newQuantity;
    notifyListeners();
  }

  // Menghapus produk dari keranjang, stok dikembalikan
  void removeFromCart(Product product) {
    final current = cartQuantities[product.id] ?? 0;
    product.stock += current;
    cartQuantities.remove(product.id);
    notifyListeners();
  }

  // Checkout mengosongkan keranjang
  void checkout() {
    cartQuantities.clear();
    notifyListeners();
  }
}