import 'package:flutter/material.dart';
import 'package:menu_fit/screens/register_screnn.dart';
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
    setState(() => _error = "Correo o contraseña inválidos"); // o usa un SnackBar
  }
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
