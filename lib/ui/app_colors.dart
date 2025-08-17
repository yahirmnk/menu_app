import 'package:flutter/material.dart';

class AppColors {
  static const Color mint = Color(0xFF86EBCB);
  static const Color sky = Color(0xFF86C9EB);
  static const Color aqua = Color(0xFF86E9EB);
  static const Color limeMint = Color(0xFF86EBA7);
  static const Color cornflower = Color(0xFF86A9EB);
  static const Color ice = Color(0xFFD3EAEB);

  // Derivados semánticos
  static const Color primary = sky;        // color principal
  static const Color onPrimary = Colors.white;
  static const Color secondary = mint;     // acentos/chips
  static const Color tertiary = cornflower;
  static const Color surface = Colors.white;
  static const Color surfaceAlt = ice;     // contenedores suaves
  static const Color outline = Color(0x1A000000); // sutil

  // Gradiente de marca
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sky, aqua, mint],
  );
}
