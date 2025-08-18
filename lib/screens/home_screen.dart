import 'package:flutter/material.dart';
import 'package:menu_fit/screens/create_recipe_screen.dart';
import '../models/user.dart';
import 'recipes_screen.dart';
import '../ui/app_colors.dart';
import 'favorites_screen.dart';
import '../services/mongo_service.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = MongoService();
  bool _hasFavorites = false;
  bool _loadingFav = true;

  @override
  void initState() {
    super.initState();
    _checkFavorites();
  }

  Future<void> _checkFavorites() async {
    setState(() => _loadingFav = true);
    try {
      final favs = await _api.getFavoriteRecipes(widget.user.id);
      setState(() {
        _hasFavorites = favs.isNotEmpty;
        _loadingFav = false;
      });
    } catch (_) {
      setState(() => _loadingFav = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final diets = [
      {"title": "Masa Muscular",        "tag": "masa_muscular"},
      {"title": "Déficit Calórico",     "tag": "deficit_calorico"},
      {"title": "Mantenimiento",        "tag": "mantenimiento"},
      {"title": "Cetogénica (Keto)",    "tag": "cetogenica"},
      {"title": "Alta en proteínas",    "tag": "alta_proteina"},
      {"title": "Vegetariana/Vegana",   "tag": "vegetariana_vegana"},
      {"title": "Mediterránea",         "tag": "mediterranea"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Bienvenido, ${widget.user.nombre}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Mis favoritos",
            icon: _loadingFav
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(
                    _hasFavorites ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
            onPressed: () async {
              // abre favoritos y al volver, refresca el estado del corazón
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(userId: widget.user.id),
                ),
              );
              if (mounted) _checkFavorites();
            },
          ),
        ],
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
                        userId: widget.user.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 8, 222, 234),
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
            bottom: 32,
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.secondary,
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
