import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa_mobile/models/address.dart';
import 'package:pa_mobile/providers/address_provider.dart';
import 'package:pa_mobile/theme/app_colors.dart';
import 'package:pa_mobile/widgets/auth_text_field.dart';

// Halaman pengelolaan alamat pengiriman, meliputi penambahan,
// pemilihan alamat utama, dan penghapusan alamat.
class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // Controller untuk mengambil dan mengatur nilai pada setiap kolom input.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  // Menyimpan pesan kesalahan ketika validasi formulir gagal.
  String errorMessage = '';

  @override
  void dispose() {
    // Melepaskan controller untuk menghindari penggunaan memori yang tidak diperlukan.
    nameController.dispose();
    phoneController.dispose();
    detailController.dispose();
    super.dispose();
  }

  // Memvalidasi formulir dan menyimpan alamat melalui AddressProvider.
  void saveAddress() {
    // Memastikan seluruh kolom telah diisi sebelum alamat disimpan.
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        detailController.text.trim().isEmpty) {
      setState(() => errorMessage = 'Semua kolom wajib diisi');
      return;
    }

    // Memanggil fungsi addAddress tanpa berlangganan perubahan data provider.
    context.read<AddressProvider>().addAddress(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      detail: detailController.text.trim(),
    );

    // Mengosongkan formulir setelah alamat berhasil dikirim ke provider.
    nameController.clear();
    phoneController.clear();
    detailController.clear();

    // Menghapus pesan kesalahan setelah proses penyimpanan.
    setState(() => errorMessage = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Alamat Pengiriman',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        // Consumer memperbarui tampilan ketika data alamat pada provider berubah.
        child: Consumer<AddressProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form untuk memasukkan informasi alamat pengiriman baru.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tambah Alamat Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Input nama penerima alamat.
                          AuthTextField(
                            controller: nameController,
                            hint: 'Nama Penerima',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),

                          // Input nomor telepon penerima.
                          AuthTextField(
                            controller: phoneController,
                            hint: 'Nomor HP',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),

                          // Input alamat lengkap dengan beberapa baris teks.
                          AuthTextField(
                            controller: detailController,
                            hint: 'Alamat lengkap (jalan, RT/RW, kota)',
                            icon: Icons.location_on_outlined,
                            maxLines: 3,
                          ),

                          // Menampilkan pesan kesalahan jika validasi gagal.
                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              errorMessage,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Tombol untuk memvalidasi dan menyimpan alamat.
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: saveAddress,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_location_alt_outlined,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Simpan Alamat',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Judul bagian yang menampilkan daftar alamat tersimpan.
                    const Text(
                      'Alamat Tersimpan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Menampilkan informasi jika belum ada alamat tersimpan.
                    if (provider.addresses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          'Belum ada alamat tersimpan',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                    // Membuat kartu untuk setiap alamat yang tersedia.
                    for (final address in provider.addresses) ...[
                      _buildAddressCard(context, provider, address),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Membuat kartu alamat yang berisi informasi penerima dan tombol pengelolaan.
  Widget _buildAddressCard(
      BuildContext context,
      AddressProvider provider,
      Address address,
      ) {
    // Memeriksa apakah alamat yang ditampilkan merupakan alamat utama.
    final isMain = provider.mainAddressId == address.id;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        // Memberikan garis tepi berbeda pada alamat yang ditetapkan sebagai utama.
        border: Border.all(
          color: isMain ? AppColors.primary : AppColors.border,
          width: isMain ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan nama penerima dan penanda alamat utama.
          Row(
            children: [
              Expanded(
                child: Text(
                  address.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isMain)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Utama',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),

          // Menampilkan nomor telepon penerima.
          Text(
            address.phone,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Menampilkan detail alamat pengiriman.
          Text(
            address.detail,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Menyediakan tombol untuk menetapkan alamat utama dan menghapus alamat.
          Row(
            children: [
              // Tombol penetapan alamat utama hanya tampil pada alamat nonutama.
              if (!isMain)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<AddressProvider>()
                        .setMain(address.id),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Jadikan Utama',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Memberikan jarak jika tombol penetapan alamat utama ditampilkan.
              if (!isMain) const SizedBox(width: 8),

              // Menghapus alamat berdasarkan ID melalui AddressProvider.
              ElevatedButton(
                onPressed: () => context
                    .read<AddressProvider>()
                    .removeAddress(address.id),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.danger,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}