import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../models/recipe.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _tiempoCtrl = TextEditingController();
  final _caloriasCtrl = TextEditingController();
  final _proteinasCtrl = TextEditingController();
  final _grasasCtrl = TextEditingController();
  final _costoCtrl = TextEditingController();

  // dietTag: "masa_muscular" | "deficit_calorico"
  String? _dietTag;

  // Ingredientes [{nombre, cantidad}]
  final List<Map<String, String>> _ingredientes = [
    {"nombre": "", "cantidad": ""}
  ];

  // Pasos / método de preparación (lista de strings)
  final List<String> _pasos = [""];

  bool _enviando = false;
  final _api = MongoService();

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _tiempoCtrl.dispose();
    _caloriasCtrl.dispose();
    _proteinasCtrl.dispose();
    _grasasCtrl.dispose();
    _costoCtrl.dispose();
    super.dispose();
  }

  void _agregarIngrediente() {
    setState(() => _ingredientes.add({"nombre": "", "cantidad": ""}));
  }

  void _eliminarIngrediente(int index) {
    setState(() {
      if (_ingredientes.length > 1) _ingredientes.removeAt(index);
    });
  }

  void _agregarPaso() {
    setState(() => _pasos.add(""));
  }

  void _eliminarPaso(int index) {
    setState(() {
      if (_pasos.length > 1) _pasos.removeAt(index);
    });
  }

  Future<void> _guardar() async {
    // Validaciones de form
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_dietTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona el tipo de dieta")),
      );
      return;
    }

    // Convertir números
    int calorias = int.tryParse(_caloriasCtrl.text.trim()) ?? 0;
    int proteinas = int.tryParse(_proteinasCtrl.text.trim()) ?? 0;
    int grasas = int.tryParse(_grasasCtrl.text.trim()) ?? 0;
    int costo = int.tryParse(_costoCtrl.text.trim()) ?? 0;

    // Limpiar listas (quitar vacíos)
    final ingredientes = _ingredientes
        .map((e) => {
              "nombre": (e["nombre"] ?? "").trim(),
              "cantidad": (e["cantidad"] ?? "").trim()
            })
        .where((e) => e["nombre"]!.isNotEmpty && e["cantidad"]!.isNotEmpty)
        .toList();

    final pasos = _pasos.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    setState(() => _enviando = true);

    final Recipe? creada = await _api.createRecipe(
      titulo: _tituloCtrl.text.trim(),
      dietTag: _dietTag!, // requerido
      ingredientes: ingredientes,
      modoPreparacion: pasos,
      calorias: calorias,
      proteinas: proteinas,
      grasas: grasas,
      tiempoPreparacion: _tiempoCtrl.text.trim(),
      costoPromedio: costo,
      // autorId: user?.id, // si luego guardas el autor
    );

    setState(() => _enviando = false);

    if (!mounted) return;

    if (creada != null) {
      // Mensaje de verificación
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("¡Gracias por tu publicación!"),
          content: const Text(
            "Tu receta fue enviada y está en revisión. "
            "Nuestro equipo la verificará en un plazo de hasta 24 horas. "
            "Una vez aprobada, aparecerá en la app."
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // cierra el diálogo
                Navigator.pop(context); // regresa a la pantalla anterior
              },
              child: const Text("Entendido"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo enviar la receta. Intenta nuevamente.")),
      );
    }
  }

  Widget _buildIngredienteItem(int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _ingredientes[index]["nombre"],
            decoration: const InputDecoration(labelText: "Ingrediente"),
            onChanged: (v) => _ingredientes[index]["nombre"] = v,
            validator: (v) {
              if ((v ?? "").trim().isEmpty) return "Requerido";
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: _ingredientes[index]["cantidad"],
            decoration: const InputDecoration(labelText: "Cantidad"),
            onChanged: (v) => _ingredientes[index]["cantidad"] = v,
            validator: (v) {
              if ((v ?? "").trim().isEmpty) return "Requerido";
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _eliminarIngrediente(index),
          icon: const Icon(Icons.remove_circle_outline),
        )
      ],
    );
  }

  Widget _buildPasoItem(int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _pasos[index],
            maxLines: 2,
            decoration: InputDecoration(labelText: "Paso ${index + 1}"),
            onChanged: (v) => _pasos[index] = v,
            validator: (v) {
              if ((v ?? "").trim().isEmpty) return "Requerido";
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _eliminarPaso(index),
          icon: const Icon(Icons.remove_circle_outline),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final diets = const [
      {"label": "Incremento de masa muscular", "value": "masa_muscular"},
      {"label": "Déficit calórico", "value": "deficit_calorico"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Publicar receta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Título
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: "Título de la receta",
                ),
                validator: (v) {
                  if ((v ?? "").trim().isEmpty) return "Ingresa un título";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Dieta (dropdown)
              DropdownButtonFormField<String>(
                value: _dietTag,
                decoration: const InputDecoration(labelText: "Tipo de dieta"),
                items: diets
                    .map((d) => DropdownMenuItem<String>(
                          value: d["value"],
                          child: Text(d["label"]!),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _dietTag = v),
                validator: (v) => v == null ? "Selecciona una dieta" : null,
              ),
              const SizedBox(height: 12),

              // Nutrientes y tiempos/costo
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caloriasCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Calorías"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _proteinasCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Proteínas (g)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _grasasCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Grasas (g)"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _tiempoCtrl,
                      decoration: const InputDecoration(labelText: "Tiempo de preparación (ej. 25 min)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Costo promedio (MXN)"),
              ),
              const SizedBox(height: 16),

              // Ingredientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Ingredientes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  IconButton(onPressed: _agregarIngrediente, icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              ...List.generate(_ingredientes.length, _buildIngredienteItem),
              const SizedBox(height: 16),

              // Pasos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Modo de preparación", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  IconButton(onPressed: _agregarPaso, icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              ...List.generate(_pasos.length, _buildPasoItem),
              const SizedBox(height: 24),

              // Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _enviando ? null : _guardar,
                  icon: _enviando
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send),
                  label: Text(_enviando ? "Enviando..." : "Publicar receta"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
