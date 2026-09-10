import 'package:flutter/material.dart';

/// Easy Poultry Manager — App Theme
/// Primary palette: deep amber/golden for egg, terracotta for meat
/// Background: soft warm dark for dark mode, clean off-white for light

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFE8841A);       // Golden Amber
  static const Color primaryDark = Color(0xFFC46A0D);
  static const Color primaryLight = Color(0xFFFFB347);
  static const Color primaryContainer = Color(0xFF3D2A0A);

  // Egg mode accent
  static const Color eggAccent = Color(0xFFF5C842);     // Egg yellow

  // Meat mode accent
  static const Color meatAccent = Color(0xFFD2522B);    // Terracotta

  // Both mode accent (combine)
  static const Color bothAccent = Color(0xFFE8841A);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF82);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Neutral — Dark Theme
  static const Color surfaceDark = Color(0xFF1A1208);
  static const Color surfaceDark2 = Color(0xFF241A0E);
  static const Color cardDark = Color(0xFF2E2010);
  static const Color cardDark2 = Color(0xFF3A2A14);
  static const Color borderDark = Color(0xFF4A3520);
  static const Color textPrimaryDark = Color(0xFFF5E6C8);
  static const Color textSecondaryDark = Color(0xFFAD9070);
  static const Color textHintDark = Color(0xFF6D5540);

  // Neutral — Light Theme
  static const Color surfaceLight = Color(0xFFFFF8EE);
  static const Color surfaceLight2 = Color(0xFFFFF0D6);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE8D5B0);
  static const Color textPrimaryLight = Color(0xFF1A1208);
  static const Color textSecondaryLight = Color(0xFF5C4020);
  static const Color textHintLight = Color(0xFF9A7A50);

  // Premium Badge
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumGoldDark = Color(0xFFB8860B);

  // Alert colors
  static const Color alertLow = Color(0xFFFFB800);      // Low stock
  static const Color alertExpiry = Color(0xFFEF5350);   // Expiring soon
  static const Color alertDue = Color(0xFF42A5F5);      // Vaccination due
}

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Outfit';

  // ── Dark Theme (default) ──────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.eggAccent,
        onSecondary: AppColors.surfaceDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHintDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        indicatorColor: AppColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.textHintDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            color: AppColors.textHintDark,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        hintStyle: const TextStyle(color: AppColors.textHintDark),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardDark2,
        selectedColor: AppColors.primaryContainer,
        labelStyle: const TextStyle(fontFamily: fontFamily, color: AppColors.textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ── Light Theme ───────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFFFE0B2),
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.eggAccent,
        onSecondary: AppColors.textPrimaryLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderLight,
      ),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardLight,
        indicatorColor: Color(0xFFFFE0B2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.textHintLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            color: AppColors.textHintLight,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
        hintStyle: const TextStyle(color: AppColors.textHintLight),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight2,
        selectedColor: const Color(0xFFFFE0B2),
        labelStyle: const TextStyle(
            fontFamily: fontFamily, color: AppColors.textPrimaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
