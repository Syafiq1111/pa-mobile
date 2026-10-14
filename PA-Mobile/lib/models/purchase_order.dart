// Satu baris barang dalam pesanan (disalin saat checkout)
class PurchaseItem {
  final String name;
  final String brand;
  final int price;
  final int quantity;

  PurchaseItem({
    required this.name,
    required this.brand,
    required this.price,
    required this.quantity,
  });

  int get subtotal => price * quantity;
}

// Satu pesanan hasil checkout, dipakai di halaman Riwayat Pembelian
class PurchaseOrder {
  final String id;
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
}