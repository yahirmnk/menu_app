import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/user.dart';
import 'home_screen.dart';
import '../ui/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final MongoService _mongoService = MongoService();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final User? user = await _mongoService.register(
      _nombreController.text.trim(),
      _correoController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else {
      setState(() => _error = "No se pudo crear el usuario.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16), // margen general
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Nombre
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Ingresa tu nombre" : null,
                ),
                const SizedBox(height: 16),

                // Correo
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  validator: (v) {
                    final text = (v ?? "").trim();
                    if (text.isEmpty) return "Ingresa tu correo";
                    final emailOk = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$').hasMatch(text);
                    return emailOk ? null : "Correo inválido";
                  },
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  validator: (v) {
                    final text = (v ?? "").trim();
                    if (text.isEmpty) return "Ingresa una contraseña";
                    if (text.length < 6) return "Mínimo 6 caracteres";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text("Crear cuenta"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
