import 'package:flutter/material.dart';
import 'package:menu_fit/screens/register_screen.dart'; // <- corregido
import '../services/mongo_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final MongoService _mongoService = MongoService();
  bool _loading = false;
  String? _error;

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = await _mongoService.login(
      _correoController.text.trim().toLowerCase(), // ⭐ normaliza
      _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (user != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else {
      setState(() => _error = "Correo o contraseña inválidos");
      setState(() => _error = "O problemas con el servidor vuelva a oprimir iniciar sesión");
    }
  }

  @override
  void dispose() {
    _correoController.dispose(); // ⭐
    _passwordController.dispose(); // ⭐
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Correo"),
              onSubmitted: (_) => _loading ? null : _login(), // opcional
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
              onSubmitted: (_) => _loading ? null : _login(), // opcional
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Ingresar"),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tienes cuenta? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Crear cuenta"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
