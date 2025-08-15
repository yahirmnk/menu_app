const express = require("express");
const router = express.Router();
const Recipe = require("../models/Recipe");

// middleware admin simple
function checkAdmin(req, res, next) {
  const key = req.header("x-admin-key");
  if (!key || key !== process.env.ADMIN_API_KEY) {
    return res.status(401).json({ message: "No autorizado" });
  }
  next();
}

router.use(checkAdmin);

// Listar pendientes
router.get("/pending", async (_req, res, next) => {
  try {
    const items = await Recipe.find({ status: "pending" }).sort({ submittedAt: 1 });
    res.json(items);
  } catch (err) { next(err); }
});

// Aprobar
router.post("/:id/approve", async (req, res, next) => {
  try {
    const reviewer = req.body?.reviewedBy || "admin";
    const rec = await Recipe.findByIdAndUpdate(
      req.params.id,
      { status: "approved", reviewedAt: new Date(), reviewedBy: reviewer, reviewNotes: null },
      { new: true }
    );
    if (!rec) return res.status(404).json({ message: "Receta no encontrada" });
    res.json(rec);
  } catch (err) { next(err); }
});

// Rechazar (con nota)
router.post("/:id/reject", async (req, res, next) => {
  try {
    const { reviewNotes = "No cumple criterios" } = req.body || {};
    const reviewer = req.body?.reviewedBy || "admin";
    const rec = await Recipe.findByIdAndUpdate(
      req.params.id,
      { status: "rejected", reviewedAt: new Date(), reviewedBy: reviewer, reviewNotes },
      { new: true }
    );
    if (!rec) return res.status(404).json({ message: "Receta no encontrada" });
    res.json(rec);
  } catch (err) { next(err); }
});

module.exports = router;
