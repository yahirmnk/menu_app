import 'package:flutter/material.dart';
import 'package:menu_fit/screens/create_recipe_screen.dart';
import '../models/user.dart';
import 'recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final diets = [
      {"title": "Masa Muscular", "tag": "masa_muscular"},
      {"title": "Déficit Calórico", "tag": "deficit_calorico"},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido, ${user.nombre}")),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80), // para que no tape el FAB
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
          ),
          itemCount: diets.length,
          itemBuilder: (context, index) {
            final diet = diets[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipesScreen(dietTag: diet["tag"]!),
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: Text(diet["title"]!, style: const TextStyle(fontSize: 18)),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Publicar receta"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
