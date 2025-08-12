import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  final String dietTag;
  const RecipesScreen({super.key, required this.dietTag});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final MongoService _mongoService = MongoService();
  List<Recipe> _recipes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    final data = await _mongoService.getRecipesByDiet(widget.dietTag);
    setState(() {
      _recipes = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recetas")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final r = _recipes[index];
                return ListTile(
                  title: Text(r.title),
                  subtitle: Text("${r.calories} kcal | ${r.protein}g proteína"),
                  trailing: Text("⭐ ${r.ratingAverage  }"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: r),
                    ));
                  },
                );
              },
            ),
    );
  }
}
