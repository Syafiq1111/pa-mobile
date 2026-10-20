import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Gambar produk dengan ukuran tetap.
// - Jika path diawali http:// atau https:// gambar diambil dari internet (Image.network)
// - Jika tidak, gambar diambil dari folder assets (Image.asset)
// Apa pun ukuran file aslinya, bingkainya selalu sama (BoxFit.cover memotong kelebihan).
class ProductImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;

  const ProductImage({
    super.key,
    required this.path,
    required this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.radius = 6,
  });

  bool get isNetwork => path.startsWith('http://') || path.startsWith('https://');

  // Tampilan jika gambar gagal dimuat (link salah, diblokir, atau tidak ada internet)
  Widget _buildError(BuildContext context, Object error, StackTrace? stackTrace) {
    return const Center(
      child: Icon(Icons.broken_image_outlined, size: 28, color: AppColors.outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: isNetwork
          ? Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        // Gambar didecode dengan ukuran kecil agar hemat memori dan tidak berat
        cacheWidth: 400,
        // Indikator loading selama gambar diunduh
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        },
        errorBuilder: _buildError,
      )
          : Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: 400,
        gaplessPlayback: true,
        errorBuilder: _buildError,
      ),
    );
  }
}