import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';
import '../models/recipe.dart';
import '../models/diet.dart';

class MongoService {
  // Asegúrate que en config.dart tengas:
  // const String apiBaseUrl = "https://menu-app-hoie.onrender.com";
  final String baseUrl = "$apiBaseUrl/api";

  // -------- utilidades internas --------
  Future<Map<String, dynamic>?> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse("$baseUrl/$endpoint");
      // ⭐ log útil para depurar rutas
      // ignore: avoid_print
      print("➡️ POST $url body=$body");

      final res = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          // ⭐ timeout para evitar cuelgues si Render tarda en “despertar”
          .timeout(const Duration(seconds: 20));

      // ⭐ log de respuesta
      // ignore: avoid_print
      print("⬅️ (${res.statusCode}) ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      // Otros códigos -> intento parsear para mostrar mensaje del backend
      try {
        final parsed = jsonDecode(res.body);
        final msg = (parsed is Map && parsed['message'] is String)
            ? parsed['message']
            : 'Error ${res.statusCode}';
        throw Exception(msg);
      } catch (_) {
        throw Exception('Error ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("❌ POST $endpoint error: $e");
      return null; // ⭐ devolvemos null para que la UI lo maneje
    }
  }

  Future<dynamic> _get(String endpoint) async {
    try {
      final url = Uri.parse("$baseUrl/$endpoint");
      // ignore: avoid_print
      print("➡️ GET  $url");

      final res = await http.get(url).timeout(const Duration(seconds: 20));

      // ignore: avoid_print
      print("⬅️ (${res.statusCode}) ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      try {
        final parsed = jsonDecode(res.body);
        final msg = (parsed is Map && parsed['message'] is String)
            ? parsed['message']
            : 'Error ${res.statusCode}';
        throw Exception(msg);
      } catch (_) {
        throw Exception('Error ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("❌ GET $endpoint error: $e");
      return null; // ⭐ devolvemos null para que la UI lo maneje
    }
  }

  // -------- auth --------
  /// Login: backend unificado { message, user: { ... } } (pero tolera usuario plano)
  Future<User?> login(String correo, String password) async {
    // ⭐ normalizamos correo para evitar fallos por mayúsculas/espacios
    final correoLimpio = correo.trim().toLowerCase();

    final data = await _post("users/login", {
      "correo": correoLimpio,
      "contrasena": password,
    });

    if (data == null) return null;

    // { message, user: {...} }
    if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
      return User.fromJson(data);
    }
    // fallback (usuario plano)
    return User.fromJson(data);
  }

  /// Registro: backend unificado { message, user: { ... } } (pero tolera usuario plano)
  Future<User?> register(String nombre, String correo, String password) async {
    final correoLimpio = correo.trim().toLowerCase(); // ⭐ normalizamos

    final data = await _post("users/register", {
      "nombre": nombre.trim(),
      "correo": correoLimpio,
      "contrasena": password,
    });

    if (data == null) return null;

    if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
      return User.fromJson(data);
    }
    return User.fromJson(data);
  }

  // -------- dietas y recetas --------
  Future<List<Diet>> getDiets() async {
    final data = await _get("diets");
    if (data is List) {
      return data.map((e) => Diet.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Recipe>> getRecipesByDiet(String dietTag) async {
    final data = await _get("recipes?dietTag=$dietTag");
    if (data is List) {
      return data.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
