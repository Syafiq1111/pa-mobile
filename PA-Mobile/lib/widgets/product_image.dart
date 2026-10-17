import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Gambar produk dengan ukuran kotak tetap (tidak berubah mengikuti gambar asli).
// - width null  : selebar parent, tinggi tetap
// - fit cover   : gambar mengisi penuh kotak (ganti ke BoxFit.contain jika
//                 ingin gambar utuh tanpa terpotong)
// - ResizeImage : gambar didecode sesuai ukuran tampil, bukan ukuran file asli,
//                 sehingga scroll dan buka halaman jauh lebih ringan
class ProductImage extends StatelessWidget {
  final String path;
  final double? width;
  final double height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.path,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final boxWidth = width ?? MediaQuery.sizeOf(context).width / 2;
    final decodeWidth = (math.max(boxWidth, height) * pixelRatio).round();

    // Mendukung asset lokal maupun URL jika nanti field image berisi link
    final ImageProvider provider =
    path.startsWith('http') ? NetworkImage(path) : AssetImage(path);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ColoredBox(
        color: AppColors.surfaceLight,
        child: Image(
          image: ResizeImage(provider, width: decodeWidth),
          fit: fit,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.image_not_supported_outlined,
                size: 28, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}