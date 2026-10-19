import 'package:flutter/material.dart';

// Model untuk menyimpan nama dan ikon kategori produk.
// Data kategori digunakan sebagai pilihan filter pada halaman produk.
class Category {
  final String name;
  final IconData icon;

  const Category({
    required this.name,
    required this.icon,
  });
}

// Daftar kategori produk yang tersedia di toko.
// Setiap kategori memiliki nama dan ikon untuk memudahkan identifikasi.
const List<Category> categoryList = [
  Category(name: 'Keyboard', icon: Icons.keyboard),
  Category(name: 'Mouse', icon: Icons.mouse),
  Category(name: 'Storage', icon: Icons.sd_storage),
  Category(name: 'Monitor', icon: Icons.monitor),
  Category(name: 'Headset', icon: Icons.headset),
  Category(name: 'RAM', icon: Icons.memory),
];