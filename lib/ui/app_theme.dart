import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      surface: AppColors.surface,
      onSurface: Colors.black87,
      background: AppColors.surface,
      onBackground: Colors.black87,
      error: Colors.red.shade400,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.surface,
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      extendedPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: StadiumBorder(),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.all(0),
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.surfaceAlt,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      selectedColor: AppColors.secondary,
      showCheckmark: false,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    iconTheme: const IconThemeData(size: 22),
    dividerTheme: DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: Colors.black54,
    ),
  );
}
