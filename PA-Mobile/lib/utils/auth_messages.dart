// Mengubah kode error FirebaseAuthException menjadi pesan yang mudah dibaca
String authErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Format email tidak valid';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email atau password salah';
    case 'email-already-in-use':
      return 'Email sudah terdaftar, silakan login';
    case 'weak-password':
      return 'Password terlalu lemah (minimal 6 karakter)';
    case 'network-request-failed':
      return 'Tidak ada koneksi internet';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan, coba lagi nanti';
    default:
      return 'Terjadi kesalahan ($code)';
  }
}