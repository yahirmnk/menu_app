const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcrypt");

// Registro de usuario
router.post("/register", async (req, res) => {
  const { nombre, email, contrasena } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "El usuario ya existe" });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);
    const newUser = new User({ nombre, email, contrasena: hashedPassword });
    await newUser.save();

    res.status(201).json(newUser);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Login de usuario
// Login de usuario
  router.post("/login", async (req, res) => {
    const { email, contrasena } = req.body; // ← Usamos email y contrasena como en la BD

    try {
      const user = await User.findOne({ email });
      if (!user) return res.status(404).json({ message: "Usuario no encontrado" });

      const isMatch = await bcrypt.compare(contrasena, user.contrasena);
      if (!isMatch) return res.status(401).json({ message: "Contraseña incorrecta" });

      res.json(user);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });


module.exports = router;
