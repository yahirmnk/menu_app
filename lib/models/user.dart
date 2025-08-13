class User {
  final String id;
  final String nombre;
  final String correo;

  User({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"], // ✅ Ya viene como string
      nombre: json["nombre"] ?? "",
      correo: json["correo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nombre": nombre,
      "correo": correo,
    };
  }
}
