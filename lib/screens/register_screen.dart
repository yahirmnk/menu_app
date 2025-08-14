import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/user.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final MongoService _mongoService = MongoService();
  bool _loading = false;
  String? _error;

  void _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    User? user = await _mongoService.register(
      _nombreController.text.trim(),
      _correoController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else {
      setState(() => _error = "Error en el registro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
