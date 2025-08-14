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
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      // 200/201 -> OK
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
      rethrow;
    }
  }

  Future<dynamic> _get(String endpoint) async {
    try {
      final url = Uri.parse("$baseUrl/$endpoint");
      final res = await http.get(url);
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
      rethrow;
    }
  }

  // -------- auth --------
  /// Login: espera del backend { message, user: { ... } }
  Future<User?> login(String correo, String password) async {
    try {
      final data = await _post("users/login", {
        "correo": correo,
        "contrasena": password,
      });

      if (data == null) return null;

      // preferimos el formato unificado { message, user }
      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        return User.fromJson(data); // tu User.fromJson ya soporta "user"
      }

      // fallback por si el backend alguna vez devuelve el usuario plano
      return User.fromJson(data);
    } catch (e) {
      // Log opcional
      // ignore: avoid_print
      print("❌ Error en login: $e");
      return null;
    }
  }

  /// Registro: espera del backend { message, user: { ... } }
  Future<User?> register(String nombre, String correo, String password) async {
    try {
      final data = await _post("users/register", {
        "nombre": nombre,
        "correo": correo,
        "contrasena": password,
      });

      if (data == null) return null;

      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        return User.fromJson(data);
      }
      return User.fromJson(data);
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error en registro: $e");
      return null;
    }
  }

  // -------- dietas y recetas (si ya las usas) --------
  Future<List<Diet>> getDiets() async {
    try {
      final data = await _get("diets");
      if (data is List) {
        return data.map((e) => Diet.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error getDiets: $e");
      return [];
    }
  }

  Future<List<Recipe>> getRecipesByDiet(String dietTag) async {
    try {
      final data = await _get("recipes?dietTag=$dietTag");
      if (data is List) {
        return data.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error getRecipesByDiet: $e");
      return [];
    }
  }
}
