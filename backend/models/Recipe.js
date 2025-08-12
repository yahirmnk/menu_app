const mongoose = require("mongoose");

const recipeSchema = new mongoose.Schema({
  titulo: String,
  dietTag: String,
  ingredientes: [
    {
      nombre: String,
      cantidad: String
    }
  ],
  modoPreparacion: [String],
  calorias: Number,
  proteinas: Number,
  grasas: Number,
  tiempoPreparacion: String,
  costoPromedio: Number,
  calificacionPromedio: Number
});

module.exports = mongoose.model("Recipe", recipeSchema, "recetas");
