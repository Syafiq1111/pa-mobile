import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/product.dart';

// Produk favorit disimpan per akun di Firestore: users/{uid}/favorites/{productId}
// Tersimpan permanen, jadi tetap ada setelah logout atau aplikasi ditutup.
class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  // Kumpulan id produk yang difavoritkan akun yang sedang login.
  final Set<String> _favoriteIds = {};

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  int get count => _favoriteIds.length;

  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _currentUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  // Memuat favorit saat login dan membersihkan data saat logout / ganti akun.
  void _onAuthChanged(User? user) {
    if (user == null) {
      _subscription?.cancel();
      _subscription = null;
      _favoriteIds.clear();
      _currentUid = null;
      notifyListeners();
      return;
    }
    if (user.uid == _currentUid) return;

    _subscription?.cancel();
    _favoriteIds.clear();
    _currentUid = user.uid;

    _subscription = _collection!.snapshots().listen(
          (snapshot) {
        _favoriteIds
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.id));
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  // Menambah atau menghapus produk dari favorit.
  // Tampilan diperbarui langsung, lalu disimpan ke Firestore.
  Future<void> toggle(Product product) async {
    final collection = _collection;
    if (collection == null) return;

    final doc = collection.doc(product.id);
    final wasFavorite = _favoriteIds.contains(product.id);

    if (wasFavorite) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();

    try {
      if (wasFavorite) {
        await doc.delete();
      } else {
        await doc.set({
          'productId': product.id,
          'name': product.name,
          'createdAt': Timestamp.now(),
        });
      }
    } catch (_) {
      // Jika gagal disimpan, kembalikan tampilan ke kondisi sebelumnya.
      if (wasFavorite) {
        _favoriteIds.add(product.id);
      } else {
        _favoriteIds.remove(product.id);
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}