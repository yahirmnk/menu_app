class Ingredient {
  final String nombre;
  final String cantidad;

  Ingredient({
    required this.nombre,
    required this.cantidad,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        nombre: (json['nombre'] ?? '').toString(),
        cantidad: (json['cantidad'] ?? '').toString(),
      );
}

class Recipe {
  final String id;

  // Nombres “UI-friendly” pero mapeados a campos del backend
  final String title;              // backend: titulo
  final String dietTag;            // backend: dietTag
  final String prepTime;           // backend: tiempoPreparacion (string tipo "25 min")

  // Listas desde backend
  final List<Ingredient> ingredientes;     // backend: ingredientes [{nombre,cantidad}]
  final List<String> modoPreparacion;      // backend: modoPreparacion [String]

  // Nutrientes y costos
  final int calories;              // backend: calorias (int)
  final int protein;               // backend: proteinas (int)
  final int fat;                   // backend: grasas (int)
  final int avgCost;               // backend: costoPromedio (int)

  // Rating
  final double ratingAverage;      // backend: calificacionPromedio (num)

  // Opcionales
  final String? status;            // pending/approved/rejected
  final String? autorId;

  Recipe({
    required this.id,
    required this.title,
    required this.dietTag,
    required this.prepTime,
    required this.ingredientes,
    required this.modoPreparacion,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.avgCost,
    required this.ratingAverage,
    this.status,
    this.autorId,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // A veces llega envuelto como { recipe: {...} }
    final map = (json['recipe'] is Map) ? (json['recipe'] as Map<String, dynamic>) : json;

    // _id puede venir como ObjectId o string
    final rawId = map['_id'];
    final id = rawId is Map ? (rawId['\$oid']?.toString() ?? rawId.toString()) : rawId?.toString() ?? '';

    // Utilidades para parseo seguro a int/double
    int _asInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? 0;
    }

    double _asDouble(dynamic v) {
      if (v is double) return v;
      if (v is num) return v.toDouble();
      return double.tryParse('$v') ?? 0.0;
    }

    return Recipe(
      id: id,
      title: (map['titulo'] ?? '').toString(),
      dietTag: (map['dietTag'] ?? '').toString(),
      prepTime: (map['tiempoPreparacion'] ?? '').toString(),

      ingredientes: (map['ingredientes'] as List? ?? [])
          .whereType<Map>() // por seguridad
          .map((e) => Ingredient.fromJson(e.cast<String, dynamic>()))
          .toList(),

      modoPreparacion: (map['modoPreparacion'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      calories: _asInt(map['calorias']),
      protein: _asInt(map['proteinas']),
      fat: _asInt(map['grasas']),
      avgCost: _asInt(map['costoPromedio']),

      ratingAverage: _asDouble(map['calificacionPromedio']),

      status: map['status']?.toString(),
      autorId: map['autorId']?.toString(),
    );
  }
}
