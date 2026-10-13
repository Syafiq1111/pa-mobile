import 'package:flutter/material.dart';

// Class Category untuk filter kategori produk
class Category {
  final String name;
  final IconData icon;

  const Category({required this.name, required this.icon});
}

// Daftar kategori yang tersedia di toko
const List<Category> categoryList = [
  Category(name: 'Keyboard', icon: Icons.keyboard),
  Category(name: 'Mouse', icon: Icons.mouse),
  Category(name: 'Storage', icon: Icons.sd_storage),
  Category(name: 'Monitor', icon: Icons.monitor),
  Category(name: 'Headset', icon: Icons.headset),
  Category(name: 'RAM', icon: Icons.memory),
];