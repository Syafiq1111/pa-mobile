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

  // Membuat Product dari dokumen Firestore (koleksi 'products')
  // Field yang kosong diberi nilai bawaan agar aplikasi tidak error
  factory Product.fromFirestore(String id, Map<String, dynamic> data) {
    final category = (data['category'] as String?) ?? 'Lainnya';
    final image = (data['image'] as String?) ?? '';

    return Product(
      id: id,
      name: (data['name'] as String?) ?? 'Tanpa Nama',
      brand: (data['brand'] as String?) ?? '-',
      category: category,
      description: (data['description'] as String?) ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      image: image.isEmpty ? defaultImage(category) : image,
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      sold: (data['sold'] as num?)?.toInt() ?? 0,
    );
  }
}

// Gambar bawaan per kategori jika field image di Firestore dikosongkan
String defaultImage(String category) {
  switch (category) {
    case 'Keyboard':
      return 'assets/images/keyboard_logitech_g512.png';
    case 'Mouse':
      return 'assets/images/mouse_logitech_g102.png';
    case 'Monitor':
      return 'assets/images/monitor_lg_24mp400.png';
    case 'Headset':
      return 'assets/images/headset_hyperx_cloud2.png';
    case 'RAM':
      return 'assets/images/ram_kingston_fury_ddr4.png';
    default:
      return 'assets/images/storage_samsung_980.png';
  }
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