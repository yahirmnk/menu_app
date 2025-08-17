import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';
import '../ui/app_colors.dart';
import '../ui/anim.dart';

class RecipesScreen extends StatefulWidget {
  final String dietTag;
  final String? userId;

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

    final alreadyLiked = r.likedBy(userId);

    // Optimistic update
    final updatedLikes = List<String>.from(r.likes);
    int updatedCount = r.likesCount;
    if (alreadyLiked) {
      if (updatedCount > 0) updatedCount--;
      updatedLikes.remove(userId);
    } else {
      updatedCount++;
      updatedLikes.add(userId);
    }

    final original = r;
    setState(() {
      _recipes[index] = r.copyWith(likes: updatedLikes, likesCount: updatedCount);
    });

    // Backend update
    final server = alreadyLiked
        ? await _mongoService.unlikeRecipe(recipeId: r.id, userId: userId)
        : await _mongoService.likeRecipe(recipeId: r.id, userId: userId);

    if (!mounted) return;

    if (server == null) {
      setState(() => _recipes[index] = original);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo actualizar el me encanta.")),
      );
    } else {
      setState(() => _recipes[index] = server);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recetas"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _recipes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = _recipes[index];
                final liked = widget.userId != null && r.likedBy(widget.userId!);

                return FadeSlide(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.ice,
                      child: Text(
                        r.title.isNotEmpty ? r.title[0].toUpperCase() : "R",
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    title: Text(r.title),
                    subtitle: Text(
                      "⏱ ${r.prepTime} • Cal: ${r.calories} • Prot: ${r.protein}g • Gras: ${r.fat}g\n"
                      "💲 ${r.avgCost}",
                      style: const TextStyle(height: 1.4),
                    ),
                    trailing: LikeSwitcher(
                      liked: liked,
                      count: r.likesCount,
                      activeColor: AppColors.limeMint,
                      onPressed: () => _toggleLike(r, index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 260),
                          pageBuilder: (_, a1, a2) => FadeTransition(
                            opacity: a1,
                            child: RecipeDetailScreen(
                              recipe: r,
                              userId: widget.userId,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}