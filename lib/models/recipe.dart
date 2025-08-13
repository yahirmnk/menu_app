class Recipe {
  final String id;
  final String title;
  final String dietTag;
  final String prepTime; // Cambié a String porque en Mongo es "25 min"
  final double calories;
  final double protein;
  final double fat;
  final double avgCost;
  final double ratingAverage;

  Recipe({
    required this.id,
    required this.title,
    required this.dietTag,
    required this.prepTime,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.avgCost,
    required this.ratingAverage,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json["_id"] is Map ? json["_id"]: json["_id"].toString(),
      title: json["titulo"],
      dietTag: json["dietTag"],
      prepTime: json["tiempoPreparacion"] ?? "",
      calories: (json["calorias"] ?? 0).toDouble(),
      protein: (json["proteinas"] ?? 0).toDouble(),
      fat: (json["grasas"] ?? 0).toDouble(),
      avgCost: (json["costoPromedio"] ?? 0).toDouble(),
      ratingAverage: (json["calificacionPromedio"] ?? 0).toDouble(),
    );
  }
}
