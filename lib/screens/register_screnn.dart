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
  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _api = MongoService();

  bool _loading = false;
  String? _error;

  Future<void> _registrar() async {
    setState(() {
      _error = null;
    });

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final nombre = _nombreCtrl.text.trim();
    final correo = _correoCtrl.text.trim().toLowerCase(); // normalizamos
    final pass = _passCtrl.text;

    setState(() => _loading = true);
    final user = await _api.register(nombre, correo, pass);
    setState(() => _loading = false);

    if (user != null) {
      // Registro OK → navegar directo al Home con el usuario creado
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        (_) => false,
      );
    } else {
      setState(() => _error = "No se pudo registrar. Intenta con otro correo.");
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear cuenta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nombre
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Ingresa tu nombre";
                  if (v.trim().length < 2) return "Nombre muy corto";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Correo
              TextFormField(
                controller: _correoCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (v) {
                  final value = (v ?? "").trim();
                  if (value.isEmpty) return "Ingresa tu correo";
                  final emailOk = RegExp(r"^[\w.+-]+@[\w-]+\.[\w.-]+$").hasMatch(value);
                  if (!emailOk) return "Correo no válido";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Contraseña
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (v) {
                  if ((v ?? "").length < 6) return "Mínimo 6 caracteres";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Confirmación
              TextFormField(
                controller: _pass2Ctrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar contraseña"),
                validator: (v) {
                  if (v != _passCtrl.text) return "Las contraseñas no coinciden";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),

              ElevatedButton(
                onPressed: _loading ? null : _registrar,
                child: _loading
                    ? const SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text("Crear cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
