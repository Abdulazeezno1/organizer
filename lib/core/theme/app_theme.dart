import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  COLOUR TOKENS
// ─────────────────────────────────────────
class AppColors {
  AppColors._(); // prevent instantiation

  // Brand
  static const Color navy = Color(0xFF0B1C48);
  static const Color blush = Color(0xFFFFD1DC);

  // Backgrounds
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0B1C48);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Feedback
  static const Color success = Color(0xFF2D7A4F); // green
  static const Color warning = Color(0xFFF5A623); // amber
  static const Color error = Color(0xFFD64045); // red

  // Priority badges
  static const Color priorityHigh = Color(0xFFD64045);
  static const Color priorityMedium = Color(0xFFF5A623);
  static const Color priorityLow = Color(0xFF2D7A4F);
}

// ─────────────────────────────────────────
//  TEXT STYLES
// ─────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Georgia', // elegant serif for headings
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.navy,
    letterSpacing: 0.3,
  );
}

// ─────────────────────────────────────────
//  THEME
// ─────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      // ── Colour scheme ──────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.navy,
        onPrimary: AppColors.textOnDark,
        secondary: AppColors.blush,
        onSecondary: AppColors.navy,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnDark,
      ),

      // ── App bar ────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.textOnDark, // this covers icons
        titleTextStyle: TextStyle(
          color: AppColors.textOnDark, // ← already white
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── Cards ──────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.navy.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ── Buttons ────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.navy, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Floating action button ─────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.textOnDark,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── Input fields ───────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),

      // ── Chips (used for priority badges) ─
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blush,
        labelStyle: const TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      // ── Bottom nav bar ─────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.navy,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Divider ────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 24,
      ),

      // ── Text theme ─────────────────────
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles.titleLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
    );
  }
}
