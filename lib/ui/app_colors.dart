import 'package:flutter/material.dart';

class AppColors {
  //  Paleta base
  static const Color mint = Color(0xFF86EBCB);        // Verde menta suave (fresco, relajante)
  static const Color sky = Color(0xFF86C9EB);         // Azul cielo pastel (principal, amigable)
  static const Color aqua = Color(0xFF86E9EB);        // Azul–turquesa claro (acuático, refrescante)
  static const Color limeMint = Color(0xFF86EBA7);    // Verde lima menta (brillante, energético)
  static const Color cornflower = Color(0xFF86A9EB);  // Azul aciano (con un toque púrpura, armónico)
  static const Color ice = Color(0xFFD3EAEB);         // Azul gris muy claro, casi blanco (fondos suaves)

  // Derivados semánticos (para UI)
  static const Color primary = sky;        // Color principal (ej. AppBar, botones primarios)
  static const Color onPrimary = Colors.white; // Texto/íconos encima de primary
  static const Color secondary = mint;     // Acentos y chips secundarios
  static const Color tertiary = cornflower;// Opción de tercer color (detalles y fondos alternos)
  static const Color surface = Colors.white; // Fondos de pantallas y tarjetas
  static const Color surfaceAlt = ice;     // Variante de superficie suave (contenedores alternativos)
  static const Color outline = Color(0x1A000000); // Bordes muy sutiles (negro con baja opacidad)

  //  Gradiente de marca (para headers, botones destacados, splash, etc.)
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sky, aqua, mint],
  );
}

