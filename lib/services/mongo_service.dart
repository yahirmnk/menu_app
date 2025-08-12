import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';
import '../models/recipe.dart';
import '../models/diet.dart';

class MongoService {
  final String baseUrl = apiBaseUrl; // Definido en config.dart

  /// LOGIN
  Future<User?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/users/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "contrasena": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      print("Error login: ${response.statusCode} -> ${response.body}");
      return null;
    }
  }

  /// OBTENER RECETAS POR DIETA
  Future<List<Recipe>> getRecipesByDiet(String dietTag) async {
    final url = Uri.parse("$baseUrl/api/recipes?dietTag=$dietTag");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Recipe.fromJson(e)).toList();
    } else {
      print("Error al obtener recetas: ${response.statusCode} -> ${response.body}");
      return [];
    }
  }

  /// OBTENER TODAS LAS DIETAS
  Future<List<Diet>> getDiets() async {
    final url = Uri.parse("$baseUrl/api/diets");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Diet.fromJson(e)).toList();
    } else {
      print("Error al obtener dietas: ${response.statusCode} -> ${response.body}");
      return [];
    }
  }
}
