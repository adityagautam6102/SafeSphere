import 'package:flutter/material.dart';

class AppTheme {
  // Core palette
  static const Color primary = Color(0xFF4DA3FF);
  static const Color primaryDark = Color(0xFF1E5FE8);
  static const Color safeGreen = Color(0xFF53F7B7);
  static const Color sosRed = Color(0xFFFF4D6D);
  static const Color routePurple = Color(0xFF9C7BFF);
  static const Color circleTeal = Color(0xFF5AE3D7);

  static const Color background = Color(0xFF070C16);
  static const Color surface = Color(0xFF101827);
  static const Color surfaceLight = Color(0xFF1A2435);

  static const Color textPrimary = Color(0xFFEAF4FF);
  static const Color textSecondary = Color(0xFF9AA9BD);

  static const Color success = safeGreen;
  static const Color error = sosRed;
  static const Color warning = Color(0xFFFFB454);

  static const LinearGradient shieldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, routePurple],
  );

  static const LinearGradient sosGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [sosRed, Color(0xFFB71C3A)],
  );

  static RadialGradient safeRingGlow = RadialGradient(
    colors: [safeGreen.withOpacity(0.22), Colors.transparent],
    radius: 1.2,
  );

  static List<BoxShadow> glow(Color color, {double blur = 24, double spread = 1}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.42),
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static ThemeData get themeData {
    final baseTextTheme = ThemeData.dark(useMaterial3: true).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryDark,
        onPrimaryContainer: textPrimary,
        secondary: routePurple,
        onSecondary: Colors.white,
        tertiary: circleTeal,
        onTertiary: Colors.black,
        surface: surface,
        onSurface: textPrimary,
        background: background,
        onBackground: textPrimary,
        error: error,
        onError: Colors.white,
        surfaceTint: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: textPrimary,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primary,
          overlayColor: Colors.white.withOpacity(0.12),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: Colors.transparent,
          side: BorderSide(color: Colors.white.withOpacity(0.12), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error.withOpacity(0.9), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface.withOpacity(0.88),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: primary.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? textPrimary : textSecondary,
          );
        }),
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ).copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.04,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.04,
            ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.03,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.03,
            ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textPrimary) ??
            const TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textSecondary) ??
            const TextStyle(color: textSecondary, fontSize: 14),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textSecondary) ??
            const TextStyle(color: textSecondary, fontSize: 12),
        labelLarge: baseTextTheme.labelLarge?.copyWith(color: textPrimary) ??
            const TextStyle(color: textPrimary, fontSize: 14),
      ),
      dividerColor: Colors.white.withOpacity(0.08),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return const Color(0xFFB7C2D3);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return surfaceLight;
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        actionTextColor: primary,
        contentTextStyle: const TextStyle(color: textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme => themeData;
} 