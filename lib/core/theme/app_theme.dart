import 'package:flutter/cupertino.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2C3E50);
  static const Color secondaryColor = Color(0xFF8A9A5B);
  static const Color accentColor = Color(0xFFC4A484);
  static const Color backgroundColor = Color(0xFFF8F5F0);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color textPrimaryColor = Color(0xFF2C3E50);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color textLightColor = Color(0xFFB8B8B8);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    letterSpacing: 8,
    color: textPrimaryColor,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize:  32,
    fontWeight: FontWeight.w400,
    letterSpacing: 4,
    color: textPrimaryColor,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 2,
    color: textPrimaryColor,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize:  14,
    fontWeight:  FontWeight.w400,
    color: textPrimaryColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    color: textSecondaryColor,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight. w500,
    letterSpacing: 2,
    color: secondaryColor,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: textSecondaryColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize:  16,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
    color: surfaceColor,
  );

  // Theme Data
  static const CupertinoThemeData theme = CupertinoThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    barBackgroundColor: primaryColor,
    textTheme: CupertinoTextThemeData(
      textStyle: bodyMedium,
      primaryColor: textPrimaryColor,
    ),
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 999.0;

  // Elevation (for shadows)
  static BoxShadow shadowSmall = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.05),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  static BoxShadow shadowMedium = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.08),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow shadowLarge = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.12),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
}