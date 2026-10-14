import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/models/purchase_order.dart';

// ChangeNotifier menyediakan mekanisme notifikasi perubahan state
class CartProvider extends ChangeNotifier {
  CartProvider() {
    // Memantau status login: data produk hanya dibaca setelah login,
    // sesuai rules Firestore (allow read: if request.auth != null)
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
          if (user == null) {
            _stopListening();
            _resetData();
            _currentUid = null;
            notifyListeners();
          } else if (user.uid != _currentUid) {
            _stopListening();
            _resetData();
            _currentUid = user.uid;
            _listenProducts();
          }
        });
  }

  // Daftar produk dari Firestore (stok sudah dikurangi isi keranjang)
  final List<Product> products = [];

  // Map id produk -> jumlah di keranjang
  final Map<String, int> cartQuantities = {};

  // Riwayat pembelian (disimpan di memori selama aplikasi berjalan)
  final List<PurchaseOrder> orders = [];

  bool isLoading = true; // true saat menunggu data pertama dari Firestore
  String? errorMessage; // pesan error jika gagal membaca Firestore

  // Jumlah yang sudah dibeli (checkout), mengurangi stok tampilan
  final Map<String, int> _purchased = {};

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _productSubscription;

  // Listener realtime ke koleksi products, perubahan di Firebase Console
  // langsung tampil di aplikasi tanpa refresh
  void _listenProducts() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _productSubscription = FirebaseFirestore.instance
        .collection('products')
        .orderBy('name')
        .snapshots()
        .listen((snapshot) {
      final loaded = snapshot.docs.map((doc) {
        final product = Product.fromFirestore(doc.id, doc.data());
        // Stok tampilan = stok di database - isi keranjang - yang sudah dibeli
        final used = (cartQuantities[product.id] ?? 0) +
            (_purchased[product.id] ?? 0);
        product.stock = (product.stock - used).clamp(0, 1000000);
        return product;
      }).toList();

      products.clear();
      products.addAll(loaded);

      // Buang isi keranjang jika produknya sudah dihapus dari database
      cartQuantities.removeWhere(
            (id, quantity) => !loaded.any((product) => product.id == id),
      );

      isLoading = false;
      errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      isLoading = false;
      errorMessage =
      'Gagal memuat produk. Periksa koneksi internet dan rules Firestore.';
      notifyListeners();
    });
  }

  void _stopListening() {
    _productSubscription?.cancel();
    _productSubscription = null;
  }

  // Mengosongkan semua data saat logout atau ganti akun
  void _resetData() {
    products.clear();
    cartQuantities.clear();
    orders.clear();
    _purchased.clear();
    isLoading = true;
    errorMessage = null;
  }

  @override
  void dispose() {
    _stopListening();
    _authSubscription?.cancel();
    super.dispose();
  }

  // Total harga seluruh isi keranjang
  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  // Jumlah seluruh item di keranjang
  int get totalItems => cartProducts.fold(0, (total, product) {
    return total + (cartQuantities[product.id] ?? 0);
  });

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

  // Checkout: isi keranjang disimpan sebagai pesanan, lalu keranjang dikosongkan
  void checkout({required String address}) {
    final purchasedProducts = cartProducts;
    if (purchasedProducts.isEmpty) return;

    final items = purchasedProducts.map((product) {
      return PurchaseItem(
        name: product.name,
        brand: product.brand,
        price: product.price,
        quantity: cartQuantities[product.id] ?? 0,
      );
    }).toList();

    orders.insert(
      0,
      PurchaseOrder(
        id: 'INV-${(orders.length + 1).toString().padLeft(3, '0')}',
        date: DateTime.now(),
        items: items,
        total: grandTotal,
        address: address,
      ),
    );

    for (final product in purchasedProducts) {
      _purchased[product.id] =
          (_purchased[product.id] ?? 0) + (cartQuantities[product.id] ?? 0);
    }

    cartQuantities.clear();
    notifyListeners();
  }
}