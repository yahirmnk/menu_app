import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/mongo_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? userId; // pásalo desde RecipesScreen

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    this.userId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final MongoService _api = MongoService();
  late Recipe _recipe;
  bool _liking = false;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Future<void> _toggleLike() async {
    final userId = widget.userId;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Necesitas iniciar sesión para dar me encanta.")),
      );
      return;
    }
    if (_liking) return;
    setState(() => _liking = true);

    final alreadyLiked = _recipe.likedBy(userId);

    // Optimista
    final original = _recipe;
    final updatedLikes = List<String>.from(_recipe.likes);
    int updatedCount = _recipe.likesCount;

    if (alreadyLiked) {
      if (updatedCount > 0) updatedCount--;
      updatedLikes.remove(userId);
    } else {
      updatedCount++;
      updatedLikes.add(userId);
    }

    setState(() {
      _recipe = _recipe.copyWith(
        likes: updatedLikes,
        likesCount: updatedCount,
      );
    });

    // Llamada real
    final server = alreadyLiked
        ? await _api.unlikeRecipe(recipeId: original.id, userId: userId)
        : await _api.likeRecipe(recipeId: original.id, userId: userId);

    if (!mounted) return;

    if (server == null) {
      // Revertir si falló
      setState(() {
        _recipe = original;
        _liking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo actualizar el me encanta.")),
      );
    } else {
      // Sincronizar con server
      setState(() {
        _recipe = server;
        _liking = false;
      });
    }
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    final liked = widget.userId != null && _recipe.likedBy(widget.userId!);

    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.title),
        actions: [
          Row(
            children: [
              IconButton(
                tooltip: liked ? "Ya no me encanta" : "Me encanta",
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                color: liked ? Colors.red : null,
                onPressed: _liking ? null : _toggleLike,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text("${_recipe.likesCount}"),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chips de info rápida
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text("Dieta: ${_recipe.dietTag}")),
                Chip(label: Text("⏱ ${_recipe.prepTime}")),
                Chip(label: Text("💲 ${_recipe.avgCost}")),
              ],
            ),

            _sectionTitle("Macronutrientes"),
            Row(
              children: [
                _macroBox("Calorías", "${_recipe.calories}"),
                const SizedBox(width: 12),
                _macroBox("Proteína", "${_recipe.protein} g"),
                const SizedBox(width: 12),
                _macroBox("Grasas", "${_recipe.fat} g"),
              ],
            ),

            _sectionTitle("Ingredientes"),
            ..._recipe.ingredientes.map((ing) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(ing.nombre),
                  trailing: Text(ing.cantidad),
                )),

            _sectionTitle("Modo de preparación"),
            ..._recipe.modoPreparacion.asMap().entries.map((e) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 12,
                    child: Text("${e.key + 1}", style: const TextStyle(fontSize: 12)),
                  ),
                  title: Text(e.value),
                )),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _liking ? null : _toggleLike,
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                label: Text(liked ? "Quitar me encanta" : "Me encanta"),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text("Total de me encantan: ${_recipe.likesCount}")),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _macroBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
