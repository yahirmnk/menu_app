import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  final String dietTag;
  final String? userId; // <- añade esto (pásalo desde HomeScreen)

  const RecipesScreen({
    super.key,
    required this.dietTag,
    this.userId,
  });

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

  Future<void> _loadRecipes() async {
    final data = await _mongoService.getRecipesByDiet(widget.dietTag);
    setState(() {
      _recipes = data;
      _loading = false;
    });
  }

  Future<void> _toggleLike(Recipe r, int index) async {
    final userId = widget.userId;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Necesitas iniciar sesión para dar me encanta.")),
      );
      return;
    }

    // Optimista: actualiza UI al instante
    final alreadyLiked = r.likes.contains(userId);
    setState(() {
      final updatedLikes = List<String>.from(r.likes);
      int updatedCount = r.likesCount;
      if (alreadyLiked) {
        updatedLikes.remove(userId);
        updatedCount = (updatedCount - 1).clamp(0, 1 << 31);
      } else {
        updatedLikes.add(userId);
        updatedCount = updatedCount + 1;
      }
      _recipes[index] = Recipe(
        id: r.id,
        title: r.title,
        dietTag: r.dietTag,
        prepTime: r.prepTime,
        ingredientes: r.ingredientes,
        modoPreparacion: r.modoPreparacion,
        calories: r.calories,
        protein: r.protein,
        fat: r.fat,
        avgCost: r.avgCost,
        likesCount: updatedCount,
        likes: updatedLikes,
        status: r.status,
        autorId: r.autorId,
      );
    });

    // Llama API real
    Recipe? server;
    if (alreadyLiked) {
      server = await _mongoService.unlikeRecipe(recipeId: r.id, userId: userId);
    } else {
      server = await _mongoService.likeRecipe(recipeId: r.id, userId: userId);
    }

    // Si fallo, revierte
    if (server == null && mounted) {
      setState(() {
        _recipes[index] = r; // revertir al original
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo actualizar el me encanta.")),
      );
    } else if (server != null && mounted) {
      // opcional: sincronizar con lo que diga el servidor
      setState(() {
        _recipes[index] = server!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recetas")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _recipes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = _recipes[index];
                final liked = widget.userId != null && r.likes.contains(widget.userId);

                return ListTile(
                  title: Text(r.title),
                  subtitle: Text(
                    "⏱ ${r.prepTime} • Cal: ${r.calories} • Prot: ${r.protein}g • Gras: ${r.fat}g\n"
                    "💲 ${r.avgCost}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${r.likesCount}"),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                        color: liked ? Colors.red : null,
                        onPressed: () => _toggleLike(r, index),
                        tooltip: liked ? "Ya no me encanta" : "Me encanta",
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r)),
                    );
                  },
                );
              },
            ),
    );
  }
}
