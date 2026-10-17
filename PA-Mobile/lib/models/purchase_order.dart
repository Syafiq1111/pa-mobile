import 'package:cloud_firestore/cloud_firestore.dart';

// Satu baris barang dalam pesanan (disalin saat checkout)
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

  int get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'brand': brand,
    'price': price,
    'quantity': quantity,
  };

  factory PurchaseItem.fromMap(Map<String, dynamic> data) {
    return PurchaseItem(
      productId: (data['productId'] as String?) ?? '',
      name: (data['name'] as String?) ?? '-',
      brand: (data['brand'] as String?) ?? '-',
      price: (data['price'] as num?)?.toInt() ?? 0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

// Satu pesanan hasil checkout, disimpan di users/{uid}/orders
class PurchaseOrder {
  final String id; // nomor invoice
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

  Map<String, dynamic> toMap() => {
    'invoice': id,
    'date': Timestamp.fromDate(date),
    'items': items.map((item) => item.toMap()).toList(),
    'total': total,
    'address': address,
  };

  factory PurchaseOrder.fromMap(Map<String, dynamic> data) {
    final rawItems = (data['items'] as List<dynamic>?) ?? [];
    return PurchaseOrder(
      id: (data['invoice'] as String?) ?? '-',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: rawItems
          .map((item) => PurchaseItem.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
      total: (data['total'] as num?)?.toInt() ?? 0,
      address: (data['address'] as String?) ?? '-',
    );
  }
}