import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;
  const FavoritesScreen({super.key, required this.userId});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _api = MongoService();
  List<Recipe> _recipes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _api.getFavoriteRecipes(widget.userId);
    setState(() {
      _recipes = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis favoritos")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
              ? const Center(child: Text("Aún no tienes recetas favoritas."))
              : ListView.separated(
                  itemCount: _recipes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = _recipes[i];
                    return ListTile(
                      title: Text(r.title),
                      subtitle: Text(
                        "⏱ ${r.prepTime} • Cal: ${r.calories} • Prot: ${r.protein}g • Gras: ${r.fat}g\n"
                        "💲 ${r.avgCost} • ❤️ ${r.likesCount}",
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              recipe: r,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
