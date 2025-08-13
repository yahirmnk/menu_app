import 'package:flutter/material.dart';
import 'services/mongo_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario antes de llamadas async

  // Prueba de conexión a la API
  final mongoService = MongoService();
  final diets = await mongoService.getDiets(); // Cambia por getRecipesByDiet o login si quieres

  print("✅ Dietas obtenidas: $diets");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}
