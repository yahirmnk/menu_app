const express = require("express");
const router = express.Router();
const Recipe = require("../models/Recipe"); // Asegúrate de crear este modelo

// Obtener recetas por dietTag
router.get("/", async (req, res) => {
  const { dietTag } = req.query;

  try {
    const query = dietTag ? { dietTag } : {};
    const recipes = await Recipe.find(query);

    // Formato adaptado a tu Recipe.fromJson
    const formatted = recipes.map(r => ({
      _id: { $oid: r._id.toString() },
      title: r.titulo,
      dietTag: r.dietTag,
      prepTimeMinutes: parseInt(r.tiempoPreparacion), // "25 min" -> 25
      nutrition: {
        calories: r.calorias,
        protein: r.proteinas,
        fat: r.grasas
      },
      avgCost: r.costoPromedio,
      ratingAverage: r.calificacionPromedio
    }));

    res.json(formatted);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
