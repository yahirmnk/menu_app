import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildLightTheme() {
  // ColorScheme pensado para Material 3 con tu paleta
  final scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,          // #00DCE5
    onPrimary: AppColors.onPrimary,      // blanco
    secondary: AppColors.secondary,      // #1FB6BB
    onSecondary: Colors.black,           // buen contraste sobre secundario claro
    tertiary: AppColors.tertiary,        // #308D91
    onTertiary: Colors.white,
    surface: AppColors.surface,          // blanco
    onSurface: Colors.black87,
    background: AppColors.surface,
    onBackground: Colors.black87,
    error: Colors.red.shade400,
    onError: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: const StadiumBorder(),
    ),

    // CardThemeData (M3)
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.all(0),
    ),

    chipTheme: ChipThemeData(
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      backgroundColor: AppColors.surfaceAlt,     // fondo suave turquesa muy claro
      selectedColor: scheme.secondary,           // chip “activo”
      checkmarkColor: Colors.black,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: const StadiumBorder(),
      side: BorderSide(color: AppColors.outline),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.tertiary, // texto/icono
        side: BorderSide(color: AppColors.tertiary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),

    iconTheme: const IconThemeData(size: 22, color: Colors.black54),

    dividerTheme: DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 12,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt, // campo con fondo claro turquesa
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: const TextStyle(color: Colors.black54),
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: Colors.black54,
    ),
  );
}
