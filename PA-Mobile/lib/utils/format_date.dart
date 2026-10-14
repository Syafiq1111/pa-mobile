// Mengubah DateTime menjadi teks, contoh: 14 Okt 2026, 09:05
String formatTanggal(DateTime date) {
  const bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${bulan[date.month - 1]} ${date.year}, $jam:$menit';
}