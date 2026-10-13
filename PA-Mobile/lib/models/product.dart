// Class Product blueprint data produk
class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final int price;
  int stock; // stok bisa berubah saat masuk keranjang
  final String image;
  final double rating;
  final int sold;

  // Constructor dengan named parameter
  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.rating,
    required this.sold,
  });
}

// Mengubah angka menjadi format Rupiah, contoh 12000000 -> Rp12.000.000
String formatRupiah(int value) {
  final text = value.toString();
  String hasil = '';
  for (int i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) {
      hasil += '.';
    }
    hasil += text[i];
  }
  return 'Rp$hasil';
}