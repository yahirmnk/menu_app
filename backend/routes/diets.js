const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");

// Conexión al esquema de dietas
const dietaSchema = new mongoose.Schema({}, { collection: "dietas", strict: false });
const Dieta = mongoose.model("Dieta", dietaSchema);

// GET /api/diets
router.get("/", async (req, res) => {
  try {
    const dietas = await Dieta.find({});
    res.json(dietas);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
