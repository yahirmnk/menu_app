class User {
  final String id;
  final String nombre;
  final String correo;

  User({required this.id, required this.nombre, required this.correo});

  factory User.fromJson(Map<String, dynamic> json) {
    String id = "";

  // Si _id es un string directamente
    if (json["_id"] is String) {
      id = json["_id"];
    }
  // Si _id es un objeto tipo {"$oid": "..."}
    else if (json["_id"] is Map && json["_id"]["\$oid"] is String) {
      id = json["_id"]["\$oid"];
    }

    return User(
      id: id,
      nombre: json["nombre"] ?? "",
      correo: json["correo"] ?? "",
    );
  }
}
