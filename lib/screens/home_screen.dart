import 'package:flutter/material.dart';
import 'package:menu_fit/screens/create_recipe_screen.dart';
import '../models/user.dart';
import 'recipes_screen.dart';
import '../ui/app_colors.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.primary, // 🔹 nuevo tono monocromático
        title: Text(
          "Bienvenido, ${user.nombre}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Grid de opciones
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
            ),
            itemCount: diets.length,
            itemBuilder: (context, index) {
              final diet = diets[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipesScreen(
                        dietTag: diet["tag"]!,
                        userId: user.id, // ✅ pásalo para likes
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 8, 222, 234), // 🔹 Fondo suave monocromático
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      diet["title"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Botón flotante
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.secondary, // 🔹 acento monocromático
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Publicar receta",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
