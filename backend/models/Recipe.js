const mongoose = require("mongoose");

const recipeSchema = new mongoose.Schema({
  titulo: { type: String, required: true },
  dietTag: { type: String, required: true },  // "masa_muscular" | "deficit_calorico"
  ingredientes: [{ nombre: String, cantidad: String }],
  modoPreparacion: [String],
  calorias: { type: Number, default: 0 },
  proteinas: { type: Number, default: 0 },
  grasas: { type: Number, default: 0 },
  tiempoPreparacion: { type: String, default: "" },
  costoPromedio: { type: Number, default: 0 },
  calificacionPromedio: { type: Number, default: 0 },
  autorId: { type: String, default: null },

  // 🔽 nuevo: flujo de aprobación
  status: {
    type: String,
    enum: ["pending", "approved", "rejected"],
    default: "pending"
  },
  submittedAt: { type: Date, default: () => new Date() },
  reviewedAt: { type: Date, default: null },
  reviewedBy: { type: String, default: null },   // email/nombre admin
  reviewNotes: { type: String, default: null },

}, { collection: "recetas", timestamps: true });

recipeSchema.index({ dietTag: 1 });
recipeSchema.index({ status: 1, createdAt: -1 });

module.exports = mongoose.model("Recipe", recipeSchema, "recetas");
