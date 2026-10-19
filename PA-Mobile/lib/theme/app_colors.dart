import 'package:flutter/material.dart';

// Palet warna aplikasi.
class AppColors {
  // Background dan surface.
  static const Color background = Color(0xFFF3FAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEDF5FA);
  static const Color surfaceContainer = Color(0xFFE7EFF4);
  static const Color surfaceContainerHigh = Color(0xFFE1E9EF);
  static const Color surfaceContainerHighest = Color(0xFFDBE4E9);
  static const Color surfaceLight = Color(0xFFEDF5FA);
  static const Color border = Color(0xFFD6E3E9);
  static const Color borderSubtle = Color(0xFFE2ECF2);

  // Warna utama.
  static const Color primary = Color(0xFF006A62);
  static const Color primaryDark = Color(0xFF005049);
  static const Color primaryContainer = Color(0xFF27A69A);
  static const Color primaryFixed = Color(0xFF84F5E8);
  static const Color primaryFixedDim = Color(0xFF66D9CC);

  // Warna sekunder dan aksen.
  static const Color secondary = Color(0xFFA7391E);
  static const Color secondaryContainer = Color(0xFFFD7958);
  static const Color secondaryFixed = Color(0xFFFFDAD2);
  static const Color accent = Color(0xFFEA580C);
  static const Color accentYellow = Color(0xFFF59E0B);

  // Warna tambahan.
  static const Color tertiary = Color(0xFF006397);
  static const Color tertiaryContainer = Color(0xFF429CDB);
  static const Color tertiaryFixed = Color(0xFFCCE5FF);

  // Warna status.
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Warna teks dan garis.
  static const Color textPrimary = Color(0xFF151D21);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF8A9A9D);
  static const Color outline = Color(0xFF6D7A77);
  static const Color outlineVariant = Color(0xFFBCC9C6);

  // Gradient.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, secondaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBarGradient = LinearGradient(
    colors: [primary, primaryContainer, secondaryContainer],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // URL logo aplikasi.
  static const String appLogoUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1XVMKE_DW3RmxkaocnIoDH1KpNLRc36VrlBN5mHVzVkklsVkTF_L1zkDwYZaOZA2GF51ufwYM3xgE_8hLSX_z9nwIbdWhua7BtWiXNRrc2oNHfD4gOkpIFKdgcHSxAIdy_7cPmV9Iyx8y88S7w4dpuJlvcCkUD8a5zpFsQ7mMdYIRDL31b3_U8VX7DErpTDZnwxZfENNEbXKHSd-XFk1xMKICZ0K99nCGRI_H1N6PW9wP3uioGuIiLp7e48';

  // Alias untuk kompatibilitas.
  static const Color red = primary;
  static const Color redDark = primaryDark;
}

class AppStyle {
  static const double radius = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 28.0;
  static const double radiusSmall = 10.0;
  static const double radiusPill = 999.0;

  static BorderRadius get card => BorderRadius.circular(radius);
  static BorderRadius get cardLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get cardXLarge => BorderRadius.circular(radiusXLarge);
  static BorderRadius get small => BorderRadius.circular(radiusSmall);
  static BorderRadius get pill => BorderRadius.circular(radiusPill);

  // Bayangan untuk komponen.
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0xFF006A62).withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF27A69A).withValues(alpha: 0.07),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get floatingDockShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}

// Widget logo BengkelKOM.
class BengkelKomLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showShadow;

  const BengkelKomLogo({
    super.key,
    this.size = 52,
    this.borderRadius = 16,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow ? AppStyle.softShadow : null,
      ),
      child: Image.network(
        AppColors.appLogoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.memory_rounded,
          size: size * 0.6,
          color: AppColors.primary,
        ),
      ),
    );
  }
}