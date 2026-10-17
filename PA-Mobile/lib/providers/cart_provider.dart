import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/models/purchase_order.dart';

// Struktur Firestore:
//   products/{productId}                 -> data produk + stok asli
//   users/{uid}                          -> identitas akun (email)
//   users/{uid}/cart/{productId}         -> isi keranjang milik akun
//   users/{uid}/orders/{orderId}         -> riwayat pembelian milik akun
class CartProvider extends ChangeNotifier {
  CartProvider() {
    // Memantau status login: data dimuat saat login dan dibersihkan saat logout
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Daftar produk dari Firestore (stok = stok asli di database)
  final List<Product> products = [];

  // Map id produk -> jumlah di keranjang
  final Map<String, int> cartQuantities = {};

  // Riwayat pembelian, terbaru di atas
  final List<PurchaseOrder> orders = [];

  bool isLoading = true; // true saat menunggu data pertama dari Firestore
  bool isCheckingOut = false; // true saat transaksi checkout berjalan
  String? errorMessage;

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _productSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _orderSubscription;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _db.collection('users').doc(uid);
  CollectionReference<Map<String, dynamic>> _cartRef(String uid) => _userDoc(uid).collection('cart');
  CollectionReference<Map<String, dynamic>> _orderRef(String uid) => _userDoc(uid).collection('orders');

  void _onAuthChanged(User? user) {
    if (user == null) {
      _stopListening();
      _resetData();
      _currentUid = null;
      notifyListeners();
      return;
    }
    if (user.uid == _currentUid) return;

    _stopListening();
    _resetData();
    _currentUid = user.uid;

    // Simpan identitas akun (email) di users/{uid}
    _userDoc(user.uid).set({'email': user.email, 'lastLogin': FieldValue.serverTimestamp()}, SetOptions(merge: true)).catchError((_) {});

    _start(user.uid);
  }

  // Memuat keranjang akun sekali, lalu mendengarkan produk & pesanan secara realtime
  Future<void> _start(String uid) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cartSnapshot = await _cartRef(uid).get();
      if (_currentUid != uid) return; // akun sudah berganti
      for (final doc in cartSnapshot.docs) {
        final quantity = (doc.data()['quantity'] as num?)?.toInt() ?? 0;
        if (quantity > 0) cartQuantities[doc.id] = quantity;
      }
    } catch (_) {
      if (_currentUid != uid) return;
      // keranjang gagal dimuat: lanjut dengan keranjang kosong
    }

    _listenProducts();
    _listenOrders(uid);
  }

  void _listenProducts() {
    _productSubscription = _db
        .collection('products')
        .orderBy('name')
        .snapshots()
        .listen(
          (snapshot) {
            products
              ..clear()
              ..addAll(snapshot.docs.map((doc) => Product.fromFirestore(doc.id, doc.data())));

            _fitCartToStock();

            isLoading = false;
            errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            isLoading = false;
            errorMessage = 'Gagal memuat produk. Periksa koneksi internet dan rules Firestore.';
            notifyListeners();
          },
        );
  }

  void _listenOrders(String uid) {
    _orderSubscription = _orderRef(uid).orderBy('date', descending: true).snapshots().listen((snapshot) {
      orders
        ..clear()
        ..addAll(snapshot.docs.map((doc) => PurchaseOrder.fromMap(doc.data())));
      notifyListeners();
    }, onError: (_) {});
  }

  // Menyesuaikan keranjang jika stok di database berubah / produk dihapus
  void _fitCartToStock() {
    final toRemove = <String>[];
    final toUpdate = <Product, int>{};

    cartQuantities.forEach((id, quantity) {
      final index = products.indexWhere((product) => product.id == id);
      if (index == -1 || products[index].stock <= 0) {
        toRemove.add(id);
      } else if (quantity > products[index].stock) {
        toUpdate[products[index]] = products[index].stock;
      }
    });

    for (final id in toRemove) {
      cartQuantities.remove(id);
      _deleteCartItem(id);
    }
    toUpdate.forEach((product, quantity) {
      cartQuantities[product.id] = quantity;
      _saveCartItem(product, quantity);
    });
  }

  void _stopListening() {
    _productSubscription?.cancel();
    _productSubscription = null;
    _orderSubscription?.cancel();
    _orderSubscription = null;
  }

  // Mengosongkan semua data saat logout atau ganti akun
  void _resetData() {
    products.clear();
    cartQuantities.clear();
    orders.clear();
    isLoading = true;
    isCheckingOut = false;
    errorMessage = null;
  }

  @override
  void dispose() {
    _stopListening();
    _authSubscription?.cancel();
    super.dispose();
  }

  // Sisa stok yang masih bisa ditambahkan ke keranjang
  int availableStock(Product product) {
    return product.stock - (cartQuantities[product.id] ?? 0);
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
    if (availableStock(product) <= 0) return;

    final quantity = (cartQuantities[product.id] ?? 0) + 1;
    cartQuantities[product.id] = quantity;
    _saveCartItem(product, quantity);
    notifyListeners();
  }

  // Mengubah jumlah produk di keranjang (maksimal sebesar stok)
  void changeQuantity(Product product, int quantity) {
    if (product.stock < 1) return;

    final newQuantity = quantity.clamp(1, product.stock);
    cartQuantities[product.id] = newQuantity;
    _saveCartItem(product, newQuantity);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cartQuantities.remove(product.id);
    _deleteCartItem(product.id);
    notifyListeners();
  }

  // Menyimpan satu item keranjang ke users/{uid}/cart/{productId}
  void _saveCartItem(Product product, int quantity) {
    final uid = _currentUid;
    if (uid == null) return;
    _cartRef(uid).doc(product.id).set({'productId': product.id, 'name': product.name, 'quantity': quantity, 'updatedAt': FieldValue.serverTimestamp()}).catchError((_) {});
  }

  void _deleteCartItem(String productId) {
    final uid = _currentUid;
    if (uid == null) return;
    _cartRef(uid).doc(productId).delete().catchError((_) {});
  }

  String _newInvoiceId() {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return 'INV-${now.year}${two(now.month)}${two(now.day)}'
        '-${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }

  // Checkout memakai transaksi Firestore: stok dicek ulang di server, dikurangi,
  // pesanan disimpan, dan keranjang akun dihapus dalam satu proses atomik.
  // Mengembalikan null jika sukses, atau pesan error jika gagal.
  Future<String?> checkout({required String address}) async {
    final uid = _currentUid;
    final items = cartProducts;
    if (uid == null || items.isEmpty) return 'Keranjang masih kosong';
    if (isCheckingOut) return 'Checkout sedang diproses';

    isCheckingOut = true;
    notifyListeners();

    // Salinan isi keranjang saat tombol checkout ditekan
    final quantities = Map<String, int>.from(cartQuantities);
    final order = PurchaseOrder(
      id: _newInvoiceId(),
      date: DateTime.now(),
      items: [for (final product in items) PurchaseItem(productId: product.id, name: product.name, brand: product.brand, price: product.price, quantity: quantities[product.id] ?? 0)],
      total: grandTotal,
      address: address,
    );
    final orderDoc = _orderRef(uid).doc();

    try {
      await _db.runTransaction((transaction) async {
        // 1. Semua pembacaan harus dilakukan sebelum penulisan
        final snapshots = <String, DocumentSnapshot<Map<String, dynamic>>>{};
        for (final product in items) {
          snapshots[product.id] = await transaction.get(_db.collection('products').doc(product.id));
        }

        // 2. Validasi stok terbaru lalu kurangi stok di database
        for (final product in items) {
          final data = snapshots[product.id]!.data();
          final quantity = quantities[product.id] ?? 0;
          if (data == null) {
            throw StateError('${product.name} sudah tidak tersedia');
          }

          final stock = (data['stock'] as num?)?.toInt() ?? 0;
          final sold = (data['sold'] as num?)?.toInt() ?? 0;
          if (stock < quantity) {
            throw StateError(stock <= 0 ? '${product.name} sudah habis' : 'Stok ${product.name} tinggal $stock');
          }

          transaction.update(_db.collection('products').doc(product.id), {'stock': stock - quantity, 'sold': sold + quantity});
          transaction.delete(_cartRef(uid).doc(product.id));
        }

        // 3. Simpan pesanan ke riwayat akun
        transaction.set(orderDoc, order.toMap());
      });

      cartQuantities.clear();
      isCheckingOut = false;
      notifyListeners();
      return null;
    } on StateError catch (e) {
      isCheckingOut = false;
      notifyListeners();
      return e.message;
    } on FirebaseException catch (e) {
      isCheckingOut = false;
      notifyListeners();
      return 'Checkout gagal (${e.code}). Periksa koneksi dan rules Firestore.';
    } catch (_) {
      isCheckingOut = false;
      notifyListeners();
      return 'Checkout gagal. Coba lagi.';
    }
  }
}
