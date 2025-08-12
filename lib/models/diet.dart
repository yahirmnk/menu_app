class Diet {
  final String id;
  final String nombre;
  final String tag;

  Diet({
    required this.id,
    required this.nombre,
    required this.tag,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      id: json["_id"]["\$oid"],
      nombre: json["nombre"],
      tag: json["tag"],
    );
  }
}
