import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';
import '../models/recipe.dart';
import '../models/diet.dart';

class MongoService {
  final String baseUrl = "$apiBaseUrl/api"; // /api definido solo aquí

  /// Método genérico para peticiones GET
  Future<dynamic> _getRequest(String endpoint) async {
    try {
      final url = Uri.parse("$baseUrl/$endpoint");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Error GET [$endpoint]: ${response.statusCode} -> ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Excepción GET [$endpoint]: $e");
      return null;
    }
  }

  /// Método genérico para peticiones POST
  Future<dynamic> _postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse("$baseUrl/$endpoint");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("❌ Error POST [$endpoint]: ${response.statusCode} -> ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Excepción POST [$endpoint]: $e");
      return null;
    }
  }

  /// LOGIN
  Future<User?> login(String correo, String password) async {
    final data = await _postRequest("users/login", {
      "correo": correo,
      "contrasena": password
    });
    return data != null ? User.fromJson(data) : null;
  }

  /// REGISTRO
  Future<User?> register(String nombre, String correo, String password) async {
    final data = await _postRequest("users/register", {
      "nombre": nombre,
      "correo": correo,
      "contrasena": password
    });
    return data != null ? User.fromJson(data) : null;
  }

  /// OBTENER RECETAS POR DIETA
  Future<List<Recipe>> getRecipesByDiet(String dietTag) async {
    final data = await _getRequest("recipes?dietTag=$dietTag");
    return data != null ? (data as List).map((e) => Recipe.fromJson(e)).toList() : [];
  }

  /// OBTENER TODAS LAS DIETAS
  Future<List<Diet>> getDiets() async {
    final data = await _getRequest("diets");
    return data != null ? (data as List).map((e) => Diet.fromJson(e)).toList() : [];
  }
}
