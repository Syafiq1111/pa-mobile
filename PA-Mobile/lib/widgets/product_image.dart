import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

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
        color: Colors.white,
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