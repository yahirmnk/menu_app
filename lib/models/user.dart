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
    // Si la respuesta viene con "user" (caso registro)
    if (json.containsKey("user") && json["user"] is Map) {
      final userData = json["user"];
      return User(
        id: userData["_id"] ?? "",
        nombre: userData["nombre"] ?? "",
        correo: userData["correo"] ?? "",
      );
    }

    // Si la respuesta viene directa (caso login)
    return User(
      id: json["_id"] ?? "",
      nombre: json["nombre"] ?? "",
      correo: json["correo"] ?? "",
    );
  }
}
