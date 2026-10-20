import 'package:flutter/material.dart';

// Light theme colors
class AppColorsLight {
  static const Color background = Color(0xFFF3FAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEDF5FA);
  static const Color surfaceContainer = Color(0xFFE7EFF4);
  static const Color surfaceContainerHigh = Color(0xFFE1E9EF);
  static const Color surfaceContainerHighest = Color(0xFFDBE4E9);
  static const Color surfaceLight = Color(0xFFEDF5FA);
  static const Color border = Color(0xFFD6E3E9);
  static const Color borderSubtle = Color(0xFFE2ECF2);
  static const Color primary = Color(0xFF006A62);
  static const Color primaryDark = Color(0xFF005049);
  static const Color primaryContainer = Color(0xFF27A69A);
  static const Color primaryFixed = Color(0xFF84F5E8);
  static const Color primaryFixedDim = Color(0xFF66D9CC);
  static const Color secondary = Color(0xFFA7391E);
  static const Color secondaryContainer = Color(0xFFFD7958);
  static const Color secondaryFixed = Color(0xFFFFDAD2);
  static const Color accent = Color(0xFFEA580C);
  static const Color accentYellow = Color(0xFFF59E0B);
  static const Color tertiary = Color(0xFF006397);
  static const Color tertiaryContainer = Color(0xFF429CDB);
  static const Color tertiaryFixed = Color(0xFFCCE5FF);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color textPrimary = Color(0xFF151D21);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF8A9A9D);
  static const Color outline = Color(0xFF6D7A77);
  static const Color outlineVariant = Color(0xFFBCC9C6);
}

// Dark theme colors
class AppColorsDark {
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceContainerLow = Color(0xFF252525);
  static const Color surfaceContainer = Color(0xFF2A2A2A);
  static const Color surfaceContainerHigh = Color(0xFF303030);
  static const Color surfaceContainerHighest = Color(0xFF353535);
  static const Color surfaceLight = Color(0xFF252525);
  static const Color border = Color(0xFF404040);
  static const Color borderSubtle = Color(0xFF353535);
  static const Color primary = Color(0xFF4CEDD8);
  static const Color primaryDark = Color(0xFF34C9B8);
  static const Color primaryContainer = Color(0xFF27A69A);
  static const Color primaryFixed = Color(0xFF84F5E8);
  static const Color primaryFixedDim = Color(0xFF66D9CC);
  static const Color secondary = Color(0xFFFFB59D);
  static const Color secondaryContainer = Color(0xFFFD7958);
  static const Color secondaryFixed = Color(0xFFFFDAD2);
  static const Color accent = Color(0xFFFFB366);
  static const Color accentYellow = Color(0xFFFBBF24);
  static const Color tertiary = Color(0xFF90C8FF);
  static const Color tertiaryContainer = Color(0xFF429CDB);
  static const Color tertiaryFixed = Color(0xFFCCE5FF);
  static const Color success = Color(0xFF86EFAC);
  static const Color warning = Color(0xFFFCD34D);
  static const Color danger = Color(0xFFFCA5A5);
  static const Color errorContainer = Color(0xFFFFB4A8);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF808080);
  static const Color outline = Color(0xFF999999);
  static const Color outlineVariant = Color(0xFF666666);
}

// Extension for context-aware colors
extension AppColorsExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground => isDarkMode ? AppColorsDark.background : AppColorsLight.background;
  Color get appSurface => isDarkMode ? AppColorsDark.surface : AppColorsLight.surface;
  Color get appSurfaceContainerLow => isDarkMode ? AppColorsDark.surfaceContainerLow : AppColorsLight.surfaceContainerLow;
  Color get appSurfaceContainer => isDarkMode ? AppColorsDark.surfaceContainer : AppColorsLight.surfaceContainer;
  Color get appSurfaceContainerHigh => isDarkMode ? AppColorsDark.surfaceContainerHigh : AppColorsLight.surfaceContainerHigh;
  Color get appSurfaceContainerHighest => isDarkMode ? AppColorsDark.surfaceContainerHighest : AppColorsLight.surfaceContainerHighest;
  Color get appSurfaceLight => isDarkMode ? AppColorsDark.surfaceLight : AppColorsLight.surfaceLight;
  Color get appBorder => isDarkMode ? AppColorsDark.border : AppColorsLight.border;
  Color get appBorderSubtle => isDarkMode ? AppColorsDark.borderSubtle : AppColorsLight.borderSubtle;
  Color get appPrimary => isDarkMode ? AppColorsDark.primary : AppColorsLight.primary;
  Color get appPrimaryDark => isDarkMode ? AppColorsDark.primaryDark : AppColorsLight.primaryDark;
  Color get appPrimaryContainer => isDarkMode ? AppColorsDark.primaryContainer : AppColorsLight.primaryContainer;
  Color get appPrimaryFixed => isDarkMode ? AppColorsDark.primaryFixed : AppColorsLight.primaryFixed;
  Color get appPrimaryFixedDim => isDarkMode ? AppColorsDark.primaryFixedDim : AppColorsLight.primaryFixedDim;
  Color get appSecondary => isDarkMode ? AppColorsDark.secondary : AppColorsLight.secondary;
  Color get appSecondaryContainer => isDarkMode ? AppColorsDark.secondaryContainer : AppColorsLight.secondaryContainer;
  Color get appSecondaryFixed => isDarkMode ? AppColorsDark.secondaryFixed : AppColorsLight.secondaryFixed;
  Color get appAccent => isDarkMode ? AppColorsDark.accent : AppColorsLight.accent;
  Color get appAccentYellow => isDarkMode ? AppColorsDark.accentYellow : AppColorsLight.accentYellow;
  Color get appTertiary => isDarkMode ? AppColorsDark.tertiary : AppColorsLight.tertiary;
  Color get appTertiaryContainer => isDarkMode ? AppColorsDark.tertiaryContainer : AppColorsLight.tertiaryContainer;
  Color get appTertiaryFixed => isDarkMode ? AppColorsDark.tertiaryFixed : AppColorsLight.tertiaryFixed;
  Color get appSuccess => isDarkMode ? AppColorsDark.success : AppColorsLight.success;
  Color get appWarning => isDarkMode ? AppColorsDark.warning : AppColorsLight.warning;
  Color get appDanger => isDarkMode ? AppColorsDark.danger : AppColorsLight.danger;
  Color get appErrorContainer => isDarkMode ? AppColorsDark.errorContainer : AppColorsLight.errorContainer;
  Color get appTextPrimary => isDarkMode ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
  Color get appTextSecondary => isDarkMode ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
  Color get appTextMuted => isDarkMode ? AppColorsDark.textMuted : AppColorsLight.textMuted;
  Color get appOutline => isDarkMode ? AppColorsDark.outline : AppColorsLight.outline;
  Color get appOutlineVariant => isDarkMode ? AppColorsDark.outlineVariant : AppColorsLight.outlineVariant;

  LinearGradient get appPrimaryGradient => LinearGradient(
    colors: [appPrimary, appPrimaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get appAccentGradient => LinearGradient(
    colors: [appSecondary, appSecondaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get appHeroBarGradient => LinearGradient(
    colors: [appPrimary, appPrimaryContainer, appSecondaryContainer],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// Backward compatibility static colors (light theme default)
class AppColors {
  static const Color background = AppColorsLight.background;
  static const Color surface = AppColorsLight.surface;
  static const Color surfaceContainerLow = AppColorsLight.surfaceContainerLow;
  static const Color surfaceContainer = AppColorsLight.surfaceContainer;
  static const Color surfaceContainerHigh = AppColorsLight.surfaceContainerHigh;
  static const Color surfaceContainerHighest = AppColorsLight.surfaceContainerHighest;
  static const Color surfaceLight = AppColorsLight.surfaceLight;
  static const Color border = AppColorsLight.border;
  static const Color borderSubtle = AppColorsLight.borderSubtle;
  static const Color primary = AppColorsLight.primary;
  static const Color primaryDark = AppColorsLight.primaryDark;
  static const Color primaryContainer = AppColorsLight.primaryContainer;
  static const Color primaryFixed = AppColorsLight.primaryFixed;
  static const Color primaryFixedDim = AppColorsLight.primaryFixedDim;
  static const Color secondary = AppColorsLight.secondary;
  static const Color secondaryContainer = AppColorsLight.secondaryContainer;
  static const Color secondaryFixed = AppColorsLight.secondaryFixed;
  static const Color accent = AppColorsLight.accent;
  static const Color accentYellow = AppColorsLight.accentYellow;
  static const Color tertiary = AppColorsLight.tertiary;
  static const Color tertiaryContainer = AppColorsLight.tertiaryContainer;
  static const Color tertiaryFixed = AppColorsLight.tertiaryFixed;
  static const Color success = AppColorsLight.success;
  static const Color warning = AppColorsLight.warning;
  static const Color danger = AppColorsLight.danger;
  static const Color errorContainer = AppColorsLight.errorContainer;
  static const Color textPrimary = AppColorsLight.textPrimary;
  static const Color textSecondary = AppColorsLight.textSecondary;
  static const Color textMuted = AppColorsLight.textMuted;
  static const Color outline = AppColorsLight.outline;
  static const Color outlineVariant = AppColorsLight.outlineVariant;

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

  static const String appLogoUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1XVMKE_DW3RmxkaocnIoDH1KpNLRc36VrlBN5mHVzVkklsVkTF_L1zkDwYZaOZA2GF51ufwYM3xgE_8hLSX_z9nwIbdWhua7BtWiXNRrc2oNHfD4gOkpIFKdgcHSxAIdy_7cPmV9Iyx8y88S7w4dpuJlvcCkUD8a5zpFsQ7mMdYIRDL31b3_U8VX7DErpTDZnwxZfENNEbXKHSd-XFk1xMKICZ0K99nCGRI_H1N6PW9wP3uioGuIiLp7e48';

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
        color: context.appSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow ? AppStyle.softShadow : null,
      ),
      child: Image.network(
        AppColors.appLogoUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.memory_rounded,
          size: size * 0.6,
          color: context.appPrimary,
        ),
      ),
    );
  }
}
