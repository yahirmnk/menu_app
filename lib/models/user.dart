class User {
  final String id;
  final String correo;
  final String nombre;

  User({required this.id, required this.correo, required this.nombre});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"]["\$oid"],
      correo: json["correo"],
      nombre: json["nombre"],
    );
  }
}
