// Alamat pengiriman, disimpan di users/{uid}/addresses
class Address {
  final String id;
  final String name;
  final String phone;
  final String detail;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.detail,
  });

  factory Address.fromFirestore(String id, Map<String, dynamic> data) {
    return Address(
      id: id,
      name: (data['name'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      detail: (data['detail'] as String?) ?? '',
    );
  }
}