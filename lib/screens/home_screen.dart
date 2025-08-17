import 'package:flutter/material.dart';
import 'package:menu_fit/screens/create_recipe_screen.dart';
import '../models/user.dart';
import 'recipes_screen.dart';
import '../ui/app_colors.dart';
import '../ui/anim.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final diets = const [
      {"title": "Masa Muscular", "tag": "masa_muscular"},
      {"title": "Déficit Calórico", "tag": "deficit_calorico"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${user.nombre}"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14,
          childAspectRatio: 1.05,
        ),
        itemCount: diets.length,
        itemBuilder: (context, index) {
          final diet = diets[index];
          return FadeSlide(
            child: PulseOnTap(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipesScreen(
                      dietTag: diet["tag"]!,
                      userId: user.id,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.cornflower, AppColors.aqua],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Center(
                  child: Text(
                    diet["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Publicar receta"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
          );
        },
      ),
    );
  }
}