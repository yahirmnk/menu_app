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
      id: json["_id"] ?? "",
      nombre: json["nombre"] ?? "",
      correo: json["correo"] ?? "",
    );
  }
}
