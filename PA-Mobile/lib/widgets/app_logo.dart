import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double radius;
  final bool showShadow;

  const AppLogo({
    super.key,
    this.size = 52,
    this.radius = 16,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow ? AppStyle.softShadow : null,
      ),
      child: Image.asset(
        'assets/images/Logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        // Gambar didecode sesuai ukuran layar agar hemat memori.
        cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.memory_rounded,
          size: size * 0.6,
          color: context.appPrimary,
        ),
      ),
    );
  }
}