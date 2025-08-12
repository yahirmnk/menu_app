import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tiempo: ${recipe.prepTime} min"),
            Text("Calorías: ${recipe.calories} kcal"),
            Text("Proteína: ${recipe.protein} g"),
            Text("Grasas: ${recipe.fat} g"),
            Text("Costo promedio: \$${recipe.avgCost}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Calificar receta"),
            ),
          ],
        ),
      ),
    );
  }
}
