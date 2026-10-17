# BengkelKOM-Ridho

Aplikasi mobile toko peralatan komputer (keyboard, mouse, storage, monitor, headset, RAM) yang dibuat dengan **Flutter** dan **Dart**. Pengguna bisa mendaftar, login, melihat produk, memfilter berdasarkan kategori, memasukkan barang ke keranjang, melakukan checkout, serta melihat riwayat pembelian dan alamat pengiriman. Data akun dan produk disimpan di **Firebase** (Authentication dan Cloud Firestore).

---

## Daftar Isi

1. [Fitur](#fitur)
2. [Teknologi](#teknologi)
3. [Cara Kerja Aplikasi](#cara-kerja-aplikasi)
4. [Struktur Folder](#struktur-folder)
5. [Penerapan Materi per Modul](#penerapan-materi-per-modul)
6. [Menghubungkan dengan Firebase dan Firestore](#menghubungkan-dengan-firebase-dan-firestore)
7. [Struktur Database Firestore](#struktur-database-firestore)

---

## Fitur

| Fitur | Penjelasan |
|---|---|
| Registrasi dan login | Email dan password lewat Firebase Authentication. Sesi tersimpan, jadi pengguna tidak perlu login ulang saat membuka aplikasi lagi. |
| Beranda | Pencarian produk (nama atau merek), banner promo, daftar kategori, dan daftar produk yang bisa difilter per kategori. |
| Halaman kategori | Filter merek, rentang harga, dan urutan (terlaris, harga terendah, harga tertinggi, rating tertinggi). |
| Produk realtime | Data produk dibaca dari Firestore. Perubahan di Firebase Console langsung tampil tanpa refresh. |
| Keranjang | Tambah, ubah jumlah (tombol atau ketik angka), dan hapus barang. Jumlah dibatasi oleh stok yang tersedia. |
| Checkout | Stok produk di database berkurang, pesanan disimpan ke riwayat, dan keranjang dikosongkan. |
| Riwayat pembelian | Daftar pesanan per akun lengkap dengan barang, alamat, dan total. |
| Alamat pengiriman | Tambah alamat, pilih alamat utama, dan hapus alamat. |
| Akun | Email akun, ringkasan keranjang, menu alamat dan riwayat, serta tombol keluar. |

Beberapa elemen tampilan masih bersifat **statis / demo** dan belum terhubung ke database: kolom voucher, biaya kirim dan asuransi pada ringkasan pembayaran, serta kartu Gold Member, Bengkel Poin, dan informasi layanan pelanggan di halaman Akun.

## Teknologi

| Teknologi | Fungsi |
|---|---|
| Flutter dan Dart | Framework dan bahasa pemrograman aplikasi |
| `provider` | State management (keranjang, produk, alamat) |
| `firebase_core` | Menghubungkan aplikasi dengan Firebase |
| `firebase_auth` | Login, registrasi, dan sesi pengguna |
| `cloud_firestore` | Database realtime untuk produk, keranjang, alamat, dan pesanan |

---

## Cara Kerja Aplikasi

### Alur halaman

```
Aplikasi dibuka
      │
      ▼
  AuthGate  ── memantau FirebaseAuth.authStateChanges()
      │
      ├── belum login ──► LoginPage ──Registrasi──► RegisterPage
      │                       │                          │
      │                       └── login berhasil ◄───────┘
      │
      └── sudah login ──► MainPage (navigasi bawah)
                              │
                              ├── Beranda ──tap kategori──► CategoryPage
                              ├── Keranjang ──Checkout──► TotalPage
                              └── Akun ──► AddressPage / OrderHistoryPage
                                       └─ Keluar ──► signOut() ──► kembali ke LoginPage
```

### Langkah-langkah

1. **Inisialisasi.** `main()` memanggil `WidgetsFlutterBinding.ensureInitialized()` lalu `Firebase.initializeApp()`. Setelah itu `MultiProvider` mendaftarkan `CartProvider` dan `AddressProvider` ke seluruh aplikasi.
2. **AuthGate.** Widget ini mendengarkan `authStateChanges()`. Jika ada sesi login, ditampilkan `MainPage`. Jika tidak ada, ditampilkan `LoginPage`. Karena itu halaman berpindah sendiri saat login, registrasi, atau logout berhasil.
3. **Membaca data per akun.** Setelah login, `CartProvider` membuka listener realtime (`snapshots()`) ke koleksi `products`, ke keranjang milik akun tersebut, dan ke riwayat pesanan akun tersebut. `AddressProvider` melakukan hal yang sama untuk alamat. Saat logout atau berganti akun, semua data di memori dikosongkan.
4. **Menampilkan produk.** `Consumer<CartProvider>` membangun ulang tampilan setiap kali `notifyListeners()` dipanggil. Stok yang tampil adalah stok di database dikurangi isi keranjang.
5. **Keranjang.** Menekan tombol tambah menulis dokumen di `users/{uid}/cart/{productId}` dengan field `quantity`. Karena listener realtime, tampilan keranjang dan badge jumlah ikut berubah.
6. **Checkout.** Dijalankan sebagai satu **transaksi Firestore**:
   - membaca stok terbaru tiap produk dan memastikan masih cukup,
   - mengurangi field `stock` di dokumen produk,
   - menyimpan pesanan ke `users/{uid}/orders`,
   - menghapus isi keranjang.

   Jika salah satu langkah gagal (misalnya stok tidak cukup), seluruh transaksi dibatalkan dan pesan error ditampilkan.
7. **Riwayat dan alamat.** Dibaca dari `users/{uid}/orders` dan `users/{uid}/addresses`. Alamat utama ikut tercatat pada pesanan saat checkout.

---

## Struktur Folder

```
pa_mobile/
├── pubspec.yaml
├── assets/
│   └── images/                    gambar produk (.png)
└── lib/
    ├── main.dart                  inisialisasi Firebase, MultiProvider, MaterialApp
    ├── firebase_options.dart      dibuat otomatis oleh FlutterFire CLI
    ├── theme/
    │   └── app_colors.dart        palet warna aplikasi
    ├── models/
    │   ├── product.dart           class Product dan formatRupiah()
    │   ├── category.dart          class Category dan daftar kategori
    │   ├── address.dart           class Address
    │   └── purchase_order.dart    class PurchaseOrder dan PurchaseItem
    ├── providers/
    │   ├── cart_provider.dart     produk, keranjang, riwayat, checkout (Firestore)
    │   └── address_provider.dart  alamat pengiriman (Firestore)
    ├── pages/
    │   ├── auth_gate.dart         pemantau status login
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── main_page.dart         Scaffold dan navigasi bawah
    │   ├── home_page.dart         Beranda
    │   ├── category_page.dart     filter per kategori
    │   ├── cart_page.dart         Keranjang
    │   ├── total_page.dart        hasil checkout
    │   ├── profile_page.dart      Akun dan logout
    │   ├── address_page.dart      Alamat pengiriman
    │   └── order_history_page.dart
    ├── widgets/
    │   ├── auth_text_field.dart   kolom input login / registrasi / alamat
    │   ├── cart_product_card.dart card barang di keranjang
    │   ├── filter_chip_button.dart
    │   ├── product_card.dart
    │   └── product_grid.dart
    └── utils/
        ├── auth_messages.dart     pesan error Firebase Auth dalam bahasa Indonesia
        └── format_date.dart       format tanggal
```

> Sesuaikan daftar ini jika ada file lain di proyekmu (misalnya widget logo atau file gaya tampilan).

---

## Penerapan Materi per Modul

### Modul 1: Pengenalan Dart dan Instalasi Flutter

| Materi | Penerapan |
|---|---|
| Variabel dan tipe data (`int`, `String`, `bool`, `double`) | Seluruh model dan state, misalnya `searchQuery`, `isLoading`, `price` |
| Fungsi | `formatRupiah()`, `formatTanggal()`, `authErrorMessage()` |
| Null safety (`?`, `??`) | `String? errorMessage`, `cartQuantities[id] ?? 0`, `Product.fromFirestore()` |
| Positional dan named parameter | Constructor memakai `required this.name` dan seterusnya, misalnya `Product(...)`, `CartPage(onCheckout: ...)` |
| Collections: `List`, `Set`, `Map` | `List<Product>` untuk produk, `Map<String, int>` untuk `cartQuantities`, `Set` untuk daftar merek unik |
| Class, property, method, constructor | `Product`, `Category`, `Address`, `PurchaseOrder`, `CartProvider`, `AddressProvider` |
| Access modifier private (`_`) | `_rawProducts`, `_currentUid`, `_startListening()` pada provider |

### Modul 2: Widget Dasar

| Widget | Penerapan |
|---|---|
| `MaterialApp`, `Scaffold`, `SafeArea` | `main.dart`, `main_page.dart` |
| `SingleChildScrollView` | Halaman Beranda, Keranjang, Akun, dan Alamat |
| `Padding`, `EdgeInsets` | Seluruh halaman |
| `Column`, `Row`, `Expanded` | Susunan semua halaman dan card |
| `Container`, `BoxDecoration` | Card produk, banner, kotak input |
| `SizedBox` | Jarak antar elemen dan ukuran tombol |
| `Text`, `TextStyle` | Seluruh teks |
| `Icon` | Ikon kategori, navigasi, dan tombol |
| `TextField`, `InputDecoration` | Pencarian produk, login, registrasi, alamat |

### Modul 3: Widget Lanjutan dan Navigation

| Materi | Penerapan |
|---|---|
| `Image.asset` | Gambar produk dari folder `assets/images/` |
| `Stack` dan `Positioned` | Label diskon pada card produk, badge jumlah keranjang, lingkaran dekorasi di halaman login |
| `BoxShadow` | Bayangan pada card form login dan bar total keranjang |
| `Navigator.push` | Login ke Registrasi, Beranda ke halaman kategori, Akun ke Alamat dan Riwayat |
| `Navigator.pop` | Tombol kembali pada halaman yang dibuka dengan `push` |
| Input hanya angka | Kolom jumlah barang di keranjang (`FilteringTextInputFormatter.digitsOnly`) |

### Modul 4: Stateful Widget

| Materi | Penerapan |
|---|---|
| `StatefulWidget` dan `setState()` | Pencarian (`searchQuery`), filter kategori, filter merek dan urutan, pergantian tab |
| State pada `ElevatedButton` | Tombol tambah ke keranjang nonaktif saat stok habis, tombol Checkout nonaktif saat total 0 atau sedang diproses |
| State pada `TextField` | `onChanged` mengubah `searchQuery`, hasilnya dipakai untuk menyaring produk |
| `TextEditingController` | Kolom jumlah di keranjang, serta kolom login, registrasi, dan alamat |
| `initState` dan `didUpdateWidget` | `CartProductCard` menyamakan teks jumlah dengan data keranjang |
| Validasi input (`updateQuantity`) | Jumlah diubah menjadi angka dan dibatasi dari 1 sampai stok maksimum |

### Modul 5: Provider

| Materi | Penerapan |
|---|---|
| State management | `CartProvider` (produk, keranjang, riwayat) dan `AddressProvider` (alamat) |
| `MultiProvider` dan `ChangeNotifierProvider` | `main.dart` |
| `ChangeNotifier` dan `notifyListeners()` | Dipanggil setiap data berubah |
| `Consumer<CartProvider>` | Beranda, kategori, keranjang, dan riwayat |
| `context.watch<...>()` | Halaman Akun dan Keranjang membaca provider lain |
| `context.read<...>()` | Memanggil `addToCart`, `removeFromCart`, `addAddress`, dan `checkout` tanpa mendengarkan perubahan |
| `setState()` hanya untuk state lokal | `searchQuery`, tab aktif, dan pilihan filter |

### Modul 6: Firebase

| Materi | Penerapan |
|---|---|
| Dependency `firebase_core`, `firebase_auth`, `cloud_firestore` | `pubspec.yaml` |
| FlutterFire CLI | Membuat `lib/firebase_options.dart` |
| `Firebase.initializeApp()` | `main.dart` |
| `AuthGate` dengan `authStateChanges()` | `pages/auth_gate.dart` |
| Login: `signInWithEmailAndPassword` | `login_page.dart` |
| Registrasi: `createUserWithEmailAndPassword` | `register_page.dart` |
| Logout: `signOut()` | `profile_page.dart` |
| Firestore realtime: `collection('products').orderBy('name').snapshots()` | `providers/cart_provider.dart` |

---

## Menghubungkan dengan Firebase dan Firestore

Lakukan langkah ini berurutan. Jalankan perintah terminal satu per satu, dari folder project.

### 1. Buat project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com) lalu klik **Create a project**.
2. Beri nama project (`bengkelkom-ridho`).
3. Catat **Project ID** di **Project settings** (ikon roda gigi), tab **General**. Project ID bisa berbeda dari nama project dan dipakai pada langkah 3.

### 2. Aktifkan Authentication

1. Buka **Authentication**, klik **Get started** jika diminta.
2. Tab **Sign-in method**, pilih **Email/Password**, aktifkan **Enable**, lalu **Save**.

### 3. Hubungkan project Flutter dengan Firebase

Pasang perangkat yang dibutuhkan (sekali saja dengan Node.js):

```
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

Lalu hubungkan project (ganti `ID_PROJECT` dengan Project ID asli):

```
flutterfire configure --project=ID_PROJECT--platforms=android,web
```

Jika perintah `flutterfire` tidak dikenali, pakai versi alternatif:

```
dart pub global run flutterfire_cli:flutterfire configure --project=ID_PROJECT_KAMU --platforms=android,web
```

Hasilnya adalah file `lib/firebase_options.dart`. File ini dibuat otomatis.

### 4. Tambah dependency

Di `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.5+1
  firebase_core: ^4.15.0
  firebase_auth: ^6.7.0
  cloud_firestore: ^6.10.0

flutter:
  assets:
    - assets/images/
```

Lalu jalankan `flutter pub get` (atau klik **Pub get** di Android Studio).

### 5. Buat database Firestore

1. Buka **Firestore Database**, klik **Create database**.
2. Pilih edisi **Standard**, pilih lokasi (`asia-southeast2` Jakarta), lalu pilih **Production mode**.

### 6. Pasang rules

Buka tab **Rules**, ganti isinya dengan aturan berikut, lalu klik **Publish**:

### 7. Isi data produk

Di tab **Data**, klik **Start collection**, isi Collection ID `products`, lalu tambahkan dokumen satu per satu. Isi field sesuai tabel di bawah. Dokumen berikutnya ditambahkan dengan **Add document**.

Data produk bisa diubah kapan saja dari Console (klik dokumen, klik nilainya, lalu **Update**) dan langsung tampil di aplikasi.

---

## Struktur Database Firestore

```
products/{productId}
users/{uid}/cart/{productId}
users/{uid}/addresses/{addressId}
users/{uid}/orders/{orderId}
```

Aplikasi memakai **uid** akun Firebase sebagai pembeda data antar pengguna.

### Koleksi `products`

Contoh satu dokumen:

| Field | Type | Value |
|---|---|---|
| name | string | Daxa M84 |
| brand | string | Rexus |
| category | string | Keyboard |
| description | string | Red Switch, TKL, RGB |
| price | int64 | 450000 |
| stock | int64 | 64 |
| image | string | assets/images/keyboard_rexus_daxa.png |
| rating | float64 | 4.5 |
| sold | int64 | 780 |

### Koleksi `users/{uid}/cart` (dibuat otomatis oleh aplikasi)

Document ID sama dengan ID produk.

| Field | Tipe | Keterangan |
|---|---|---|
| `quantity` | number | Jumlah produk di keranjang |

### Koleksi `users/{uid}/addresses` (dibuat otomatis oleh aplikasi)

| Field | Tipe | Keterangan |
|---|---|---|
| `name` | string | Nama penerima |
| `phone` | string | Nomor HP |
| `detail` | string | Alamat lengkap |
| `isMain` | boolean | `true` untuk alamat utama |
| `createdAt` | timestamp | Waktu alamat dibuat |

### Koleksi `users/{uid}/orders` (dibuat otomatis oleh aplikasi)

| Field | Tipe | Keterangan |
|---|---|---|
| `code` | string | Kode pesanan, contoh `INV-A1B2C3` |
| `createdAt` | timestamp | Waktu checkout |
| `total` | number | Total pembayaran |
| `address` | string | Alamat utama saat checkout |
| `items` | array of map | Tiap item berisi `productId`, `name`, `brand`, `image`, `price`, `quantity` |
