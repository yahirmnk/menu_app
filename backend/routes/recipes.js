const express = require("express");
const router = express.Router();
const Recipe = require("../models/Recipe");
const mongoose = require("mongoose");

// CREATE - publicar receta (queda en pending)
router.post("/", async (req, res, next) => {
  try {
    const {
      titulo, dietTag,
      ingredientes = [], modoPreparacion = [],
      calorias = 0, proteinas = 0, grasas = 0,
      tiempoPreparacion = "", costoPromedio = 0,
      autorId = null,
    } = req.body;

    if (!titulo || !dietTag) {
      return res.status(400).json({ message: "titulo y dietTag son requeridos" });
    }

    const nueva = await Recipe.create({
      titulo, dietTag, ingredientes, modoPreparacion,
      calorias, proteinas, grasas,
      tiempoPreparacion, costoPromedio,
      autorId,
      status: "pending",              //clave
      submittedAt: new Date()
    });

    return res.status(201).json(nueva);
  } catch (err) { next(err); }
});

// READ - público: solo approved
router.get("/", async (req, res, next) => {
  try {
    const { dietTag } = req.query;
    const filter = { status: "approved", ...(dietTag ? { dietTag } : {}) };
    const recetas = await Recipe.find(filter).sort({ createdAt: -1 });
    return res.json(recetas);
  } catch (err) { next(err); }
});

// READ - detalle (solo approved)
router.get("/:id", async (req, res, next) => {
  try {
    const receta = await Recipe.findOne({ _id: req.params.id, status: "approved" });
    if (!receta) return res.status(404).json({ message: "Receta no encontrada o no aprobada" });
    return res.json(receta);
  } catch (err) { next(err); }
});

// ❤️ dar like (me encanta)
router.post("/:id/like", async (req, res, next) => {
  try {
    const { id } = req.params;
    const { userId } = req.body || {};

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: "ID inválido" });
    }
    if (!userId) {
      return res.status(400).json({ message: "userId es requerido" });
    }

    // addToSet evita duplicados; incrementamos likesCount
    let rec = await Recipe.findByIdAndUpdate(
      id,
      {
        $addToSet: { likes: userId },
        $inc: { likesCount: 1 }
      },
      { new: true }
    );

    if (!rec) return res.status(404).json({ message: "Receta no encontrada" });

    // Corrección de seguridad: si ya existía, addToSet no duplica, así que ajusta el contador
    if (Array.isArray(rec.likes)) {
      const real = rec.likes.length;
      if (rec.likesCount !== real) {
        rec.likesCount = real;
        rec = await rec.save();
      }
    }

    return res.json(rec);
  } catch (err) { next(err); }
});

// 💔 quitar like
router.post("/:id/unlike", async (req, res, next) => {
  try {
    const { id } = req.params;
    const { userId } = req.body || {};

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: "ID inválido" });
    }
    if (!userId) {
      return res.status(400).json({ message: "userId es requerido" });
    }

    let rec = await Recipe.findByIdAndUpdate(
      id,
      {
        $pull: { likes: userId },
        $inc: { likesCount: -1 }
      },
      { new: true }
    );

    if (!rec) return res.status(404).json({ message: "Receta no encontrada" });

    // Corrección de seguridad: no negativos y que coincida con el array
    if (Array.isArray(rec.likes)) {
      const real = Math.max(0, rec.likes.length);
      if (rec.likesCount !== real) {
        rec.likesCount = real;
        rec = await rec.save();
      }
    }

    return res.json(rec);
  } catch (err) { next(err); }
});

module.exports = router;
