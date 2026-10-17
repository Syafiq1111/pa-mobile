import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/address.dart';

// Alamat disimpan per akun di Firestore: users/{uid}/addresses/{addressId}
class AddressProvider extends ChangeNotifier {
  AddressProvider() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  final List<Address> addresses = [];
  String? mainAddressId;

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  Address? get mainAddress {
    for (final address in addresses) {
      if (address.id == mainAddressId) return address;
    }
    return null;
  }

  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _currentUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses');
  }

  void _onAuthChanged(User? user) {
    if (user == null) {
      _subscription?.cancel();
      _subscription = null;
      addresses.clear();
      mainAddressId = null;
      _currentUid = null;
      notifyListeners();
      return;
    }
    if (user.uid == _currentUid) return;

    _subscription?.cancel();
    addresses.clear();
    mainAddressId = null;
    _currentUid = user.uid;

    _subscription = _collection!.orderBy('createdAt').snapshots().listen(
          (snapshot) {
        addresses
          ..clear()
          ..addAll(snapshot.docs
              .map((doc) => Address.fromFirestore(doc.id, doc.data())));

        String? main;
        for (final doc in snapshot.docs) {
          if (doc.data()['isMain'] == true) {
            main = doc.id;
            break;
          }
        }
        // Jika belum ada yang ditandai utama, alamat pertama dianggap utama
        mainAddressId = main ?? (addresses.isNotEmpty ? addresses.first.id : null);
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  // Alamat pertama otomatis menjadi alamat utama
  Future<void> addAddress({
    required String name,
    required String phone,
    required String detail,
  }) async {
    final collection = _collection;
    if (collection == null) return;
    try {
      await collection.add({
        'name': name,
        'phone': phone,
        'detail': detail,
        'isMain': addresses.isEmpty,
        'createdAt': Timestamp.now(),
      });
    } catch (_) {}
  }

  Future<void> setMain(String id) async {
    final collection = _collection;
    if (collection == null) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final address in addresses) {
      batch.update(collection.doc(address.id), {'isMain': address.id == id});
    }
    try {
      await batch.commit();
    } catch (_) {}
  }

  Future<void> removeAddress(String id) async {
    final collection = _collection;
    if (collection == null) return;

    final wasMain = mainAddressId == id;
    final batch = FirebaseFirestore.instance.batch();
    batch.delete(collection.doc(id));

    // Jika alamat utama dihapus, alamat berikutnya menjadi utama
    if (wasMain) {
      final rest = addresses.where((address) => address.id != id).toList();
      if (rest.isNotEmpty) {
        batch.update(collection.doc(rest.first.id), {'isMain': true});
      }
    }
    try {
      await batch.commit();
    } catch (_) {}
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}