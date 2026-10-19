import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';
import 'package:pa_mobile/models/purchase_order.dart';

class CartProvider extends ChangeNotifier {
  // Inisialisasi provider dan pemantauan status login.
  CartProvider() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<Product> products = [];
  final Map<String, int> cartQuantities = {};
  final List<PurchaseOrder> orders = [];

  bool isLoading = true;
  bool isCheckingOut = false;
  String? errorMessage;

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _productSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _orderSubscription;

  // Mengakses dokumen akun, keranjang, dan pesanan.
  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _cartRef(String uid) =>
      _userDoc(uid).collection('cart');

  CollectionReference<Map<String, dynamic>> _orderRef(String uid) =>
      _userDoc(uid).collection('orders');

  // Memuat data sesuai akun yang sedang login.
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

    _userDoc(user.uid)
        .set({
      'email': user.email,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true))
        .catchError((_) {});

    _start(user.uid);
  }

  // Mengambil keranjang dan memulai pemantauan data.
  Future<void> _start(String uid) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cartSnapshot = await _cartRef(uid).get();

      if (_currentUid != uid) return;

      for (final doc in cartSnapshot.docs) {
        final quantity = (doc.data()['quantity'] as num?)?.toInt() ?? 0;

        if (quantity > 0) {
          cartQuantities[doc.id] = quantity;
        }
      }
    } catch (_) {
      if (_currentUid != uid) return;
    }

    _listenProducts();
    _listenOrders(uid);
  }

  // Mengambil data produk secara realtime.
  void _listenProducts() {
    _productSubscription = _db
        .collection('products')
        .orderBy('name')
        .snapshots()
        .listen(
          (snapshot) {
        products
          ..clear()
          ..addAll(
            snapshot.docs.map(
                  (doc) => Product.fromFirestore(doc.id, doc.data()),
            ),
          );

        _fitCartToStock();

        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        isLoading = false;
        errorMessage =
        'Gagal memuat produk. Periksa koneksi internet dan rules Firestore.';
        notifyListeners();
      },
    );
  }

  // Mengambil riwayat pesanan berdasarkan tanggal.
  void _listenOrders(String uid) {
    _orderSubscription = _orderRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        orders
          ..clear()
          ..addAll(
            snapshot.docs.map(
                  (doc) => PurchaseOrder.fromMap(doc.data()),
            ),
          );

        notifyListeners();
      },
      onError: (_) {},
    );
  }

  // Menyesuaikan keranjang dengan stok terbaru.
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

  // Menghentikan pemantauan data dan membersihkan subscription.
  void _stopListening() {
    _productSubscription?.cancel();
    _productSubscription = null;

    _orderSubscription?.cancel();
    _orderSubscription = null;
  }

  // Menghapus data lokal saat logout atau berganti akun.
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

  // Menghitung stok yang masih tersedia untuk ditambahkan.
  int availableStock(Product product) {
    return product.stock - (cartQuantities[product.id] ?? 0);
  }

  // Menghitung total harga seluruh keranjang.
  int get grandTotal => products.fold(0, (total, product) {
    return total + product.price * (cartQuantities[product.id] ?? 0);
  });

  // Menghitung jumlah seluruh barang di keranjang.
  int get totalItems => cartProducts.fold(0, (total, product) {
    return total + (cartQuantities[product.id] ?? 0);
  });

  // Mengambil daftar produk yang ada di keranjang.
  List<Product> get cartProducts {
    return products.where((product) {
      return (cartQuantities[product.id] ?? 0) > 0;
    }).toList();
  }

  // Menambahkan produk ke keranjang.
  void addToCart(Product product) {
    if (availableStock(product) <= 0) return;

    final quantity = (cartQuantities[product.id] ?? 0) + 1;
    cartQuantities[product.id] = quantity;

    _saveCartItem(product, quantity);
    notifyListeners();
  }

  // Mengubah jumlah produk sesuai batas stok.
  void changeQuantity(Product product, int quantity) {
    if (product.stock < 1) return;

    final newQuantity = quantity.clamp(1, product.stock);
    cartQuantities[product.id] = newQuantity;

    _saveCartItem(product, newQuantity);
    notifyListeners();
  }

  // Menghapus produk dari keranjang.
  void removeFromCart(Product product) {
    cartQuantities.remove(product.id);
    _deleteCartItem(product.id);
    notifyListeners();
  }

  // Menyimpan perubahan item keranjang ke Firestore.
  void _saveCartItem(Product product, int quantity) {
    final uid = _currentUid;
    if (uid == null) return;

    _cartRef(uid).doc(product.id).set({
      'productId': product.id,
      'name': product.name,
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    }).catchError((_) {});
  }

  // Menghapus item keranjang dari Firestore.
  void _deleteCartItem(String productId) {
    final uid = _currentUid;
    if (uid == null) return;

    _cartRef(uid).doc(productId).delete().catchError((_) {});
  }

  // Membuat nomor invoice berdasarkan waktu.
  String _newInvoiceId() {
    final now = DateTime.now();

    String two(int value) => value.toString().padLeft(2, '0');

    return 'INV-${now.year}${two(now.month)}${two(now.day)}'
        '-${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }

  // Memvalidasi stok dan menyimpan pesanan melalui transaksi.
  Future<String?> checkout({required String address}) async {
    final uid = _currentUid;
    final items = cartProducts;

    if (uid == null || items.isEmpty) {
      return 'Keranjang masih kosong';
    }

    if (isCheckingOut) {
      return 'Checkout sedang diproses';
    }

    isCheckingOut = true;
    notifyListeners();

    final quantities = Map<String, int>.from(cartQuantities);

    final order = PurchaseOrder(
      id: _newInvoiceId(),
      date: DateTime.now(),
      items: [
        for (final product in items)
          PurchaseItem(
            productId: product.id,
            name: product.name,
            brand: product.brand,
            price: product.price,
            quantity: quantities[product.id] ?? 0,
          ),
      ],
      total: grandTotal,
      address: address,
    );

    final orderDoc = _orderRef(uid).doc();

    try {
      await _db.runTransaction((transaction) async {
        final snapshots =
        <String, DocumentSnapshot<Map<String, dynamic>>>{};

        // Membaca semua produk sebelum melakukan perubahan.
        for (final product in items) {
          snapshots[product.id] = await transaction.get(
            _db.collection('products').doc(product.id),
          );
        }

        // Memeriksa stok dan memperbarui data produk.
        for (final product in items) {
          final data = snapshots[product.id]!.data();
          final quantity = quantities[product.id] ?? 0;

          if (data == null) {
            throw StateError('${product.name} sudah tidak tersedia');
          }

          final stock = (data['stock'] as num?)?.toInt() ?? 0;
          final sold = (data['sold'] as num?)?.toInt() ?? 0;

          if (stock < quantity) {
            throw StateError(
              stock <= 0
                  ? '${product.name} sudah habis'
                  : 'Stok ${product.name} tinggal $stock',
            );
          }

          transaction.update(
            _db.collection('products').doc(product.id),
            {
              'stock': stock - quantity,
              'sold': sold + quantity,
            },
          );

          transaction.delete(_cartRef(uid).doc(product.id));
        }

        // Menyimpan pesanan ke riwayat pembelian.
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