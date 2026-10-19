import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk menyimpan informasi satu barang dalam pesanan.
// Data barang disalin saat checkout agar detail pesanan tetap tersimpan.
class PurchaseItem {
  final String productId;
  final String name;
  final String brand;
  final int price;
  final int quantity;

  PurchaseItem({
    required this.name,
    required this.brand,
    required this.price,
    required this.quantity,
    this.productId = '',
  });

  // Menghitung subtotal harga berdasarkan harga satuan dan jumlah barang.
  int get subtotal => price * quantity;

  // Mengubah data barang menjadi Map agar dapat disimpan di Firestore.
  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'brand': brand,
    'price': price,
    'quantity': quantity,
  };

  // Membuat objek PurchaseItem dari data Map yang diperoleh dari Firestore.
  factory PurchaseItem.fromMap(Map<String, dynamic> data) {
    return PurchaseItem(
      productId: (data['productId'] as String?) ?? '',
      name: (data['name'] as String?) ?? '-',
      brand: (data['brand'] as String?) ?? '-',
      // Mengonversi nilai numerik menjadi integer dan menggunakan 0 jika kosong.
      price: (data['price'] as num?)?.toInt() ?? 0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

// Model untuk menyimpan informasi satu pesanan hasil checkout.
// Data pesanan disimpan pada koleksi users/{uid}/orders di Firestore.
class PurchaseOrder {
  final String id; // Nomor invoice pesanan.
  final DateTime date;
  final List<PurchaseItem> items;
  final int total;
  final String address;

  PurchaseOrder({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.address,
  });

  // Mengubah objek pesanan menjadi Map untuk penyimpanan di Firestore.
  Map<String, dynamic> toMap() => {
    'invoice': id,
    // Mengonversi DateTime menjadi Timestamp agar sesuai dengan format Firestore.
    'date': Timestamp.fromDate(date),
    // Mengubah setiap barang menjadi Map sebelum disimpan sebagai daftar.
    'items': items.map((item) => item.toMap()).toList(),
    'total': total,
    'address': address,
  };

  // Membuat objek PurchaseOrder dari data Map yang diperoleh dari Firestore.
  factory PurchaseOrder.fromMap(Map<String, dynamic> data) {
    // Mengambil daftar barang pesanan atau menggunakan daftar kosong jika tidak tersedia.
    final rawItems = (data['items'] as List<dynamic>?) ?? [];

    return PurchaseOrder(
      // Mengambil nomor invoice dan menggunakan tanda '-' jika tidak tersedia.
      id: (data['invoice'] as String?) ?? '-',
      // Mengonversi Timestamp menjadi DateTime.
      // Jika tanggal tidak tersedia, digunakan waktu saat ini.
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // Mengonversi setiap data barang menjadi objek PurchaseItem.
      items: rawItems
          .map(
            (item) => PurchaseItem.fromMap(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      // Mengonversi total pesanan menjadi integer.
      total: (data['total'] as num?)?.toInt() ?? 0,
      // Mengambil alamat pengiriman atau menggunakan tanda '-' jika kosong.
      address: (data['address'] as String?) ?? '-',
    );
  }
}