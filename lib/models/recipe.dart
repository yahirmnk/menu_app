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

  // Campos principales (mapeados desde backend)
  final String title;       // backend: titulo
  final String dietTag;     // backend: dietTag
  final String prepTime;    // backend: tiempoPreparacion

  // Listas desde backend
  final List<Ingredient> ingredientes; // backend: ingredientes [{nombre,cantidad}]
  final List<String> modoPreparacion;  // backend: modoPreparacion [String]

  // Nutrientes y costos
  final int calories;       // backend: calorias
  final int protein;        // backend: proteinas
  final int fat;            // backend: grasas
  final int avgCost;        // backend: costoPromedio

  // Estado/autor
  final String? status;     // pending/approved/rejected
  final String? autorId;

  // ❤️ Likes
  final int likesCount;     // backend: likesCount
  final List<String> likes; // backend: likes (userId list)

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
    this.status,
    this.autorId,
    this.likesCount = 0,
    this.likes = const [],
  });

  // Helpers de parseo seguros (evita errores con num/string)
  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final map = (json['recipe'] is Map)
        ? (json['recipe'] as Map<String, dynamic>)
        : json;

    // _id puede venir como string o como {"$oid": "..."}
    final rawId = map['_id'];
    final id = rawId is Map
        ? (rawId['\$oid']?.toString() ?? rawId.toString())
        : rawId?.toString() ?? '';

    return Recipe(
      id: id,
      title: (map['titulo'] ?? '').toString(),
      dietTag: (map['dietTag'] ?? '').toString(),
      prepTime: (map['tiempoPreparacion'] ?? '').toString(),

      ingredientes: (map['ingredientes'] as List? ?? [])
          .whereType<Map>()
          .map((e) => Ingredient.fromJson(e.cast<String, dynamic>()))
          .toList(),

      modoPreparacion: (map['modoPreparacion'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      calories: _asInt(map['calorias']),
      protein: _asInt(map['proteinas']),
      fat: _asInt(map['grasas']),
      avgCost: _asInt(map['costoPromedio']),

      status: map['status']?.toString(),
      autorId: map['autorId']?.toString(),

      likesCount: _asInt(map['likesCount']),
      likes: ((map['likes'] as List?) ?? []).map((e) => e.toString()).toList(),
    );
  }

  // Utilidad para UI (saber si un usuario ya dio "me encanta")
  bool likedBy(String userId) => likes.contains(userId);

  // 🔹 Nuevo: copyWith para actualizar solo algunos campos sin perder el resto
  Recipe copyWith({
    String? id,
    String? title,
    String? dietTag,
    String? prepTime,
    List<Ingredient>? ingredientes,
    List<String>? modoPreparacion,
    int? calories,
    int? protein,
    int? fat,
    int? avgCost,
    String? status,
    String? autorId,
    int? likesCount,
    List<String>? likes,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      dietTag: dietTag ?? this.dietTag,
      prepTime: prepTime ?? this.prepTime,
      ingredientes: ingredientes ?? this.ingredientes,
      modoPreparacion: modoPreparacion ?? this.modoPreparacion,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      avgCost: avgCost ?? this.avgCost,
      status: status ?? this.status,
      autorId: autorId ?? this.autorId,
      likesCount: likesCount ?? this.likesCount,
      likes: likes ?? this.likes,
    );
  }
}
