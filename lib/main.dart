import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'ui/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas App',
      theme: buildLightTheme(),
      home: const LoginScreen(),
    );
  }
}
