import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/models/address.dart';

// Provider alamat pengiriman (disimpan di memori selama aplikasi berjalan)
class AddressProvider extends ChangeNotifier {
  AddressProvider() {
    // Alamat dikosongkan saat logout atau ganti akun
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
          if (user?.uid != _currentUid) {
            _currentUid = user?.uid;
            addresses.clear();
            mainAddressId = null;
            notifyListeners();
          }
        });
  }

  final List<Address> addresses = [];
  String? mainAddressId; // id alamat utama

  String? _currentUid;
  StreamSubscription<User?>? _authSubscription;
  int _counter = 0;

  // Alamat utama, null jika belum ada alamat
  Address? get mainAddress {
    for (final address in addresses) {
      if (address.id == mainAddressId) return address;
    }
    return null;
  }

  void addAddress({
    required String name,
    required String phone,
    required String detail,
  }) {
    _counter++;
    final address = Address(
      id: 'addr$_counter',
      name: name,
      phone: phone,
      detail: detail,
    );
    addresses.add(address);
    // Alamat pertama otomatis menjadi alamat utama
    mainAddressId ??= address.id;
    notifyListeners();
  }

  void setMain(String id) {
    mainAddressId = id;
    notifyListeners();
  }

  void removeAddress(String id) {
    addresses.removeWhere((address) => address.id == id);
    if (mainAddressId == id) {
      mainAddressId = addresses.isEmpty ? null : addresses.first.id;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}