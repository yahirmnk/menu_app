import 'package:flutter/material.dart';

class AppColors {
  // Paleta base (monocromática turquesa–azulada)
  static const Color cyanBright = Color(0xFF00DCE5);  // principal (botones, resaltes)
  static const Color cyanMedium = Color.fromARGB(255, 3, 86, 88);  // secundarios, chips
  static const Color cyanDark = Color(0xFF308D91);    // títulos, iconos destacados
  static const Color tealGray = Color(0xFF336466);    // barras, sombras suaves
  static const Color deepTeal = Color(0xFF283B3C);    // texto principal, fondos oscuros

  // Semánticos (mapeados)
  static const Color primary = cyanBright;
  static const Color onPrimary = Colors.white;
  static const Color secondary = cyanMedium;
  static const Color tertiary = cyanDark;
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFE5F9FA); // un derivado muy claro para fondos
  static const Color outline = Color(0x1A000000); // bordes sutiles

  // Gradiente de marca (entre claros y medios)
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyanBright, cyanMedium, cyanDark],
  );
}
