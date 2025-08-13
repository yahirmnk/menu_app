const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcrypt");

// Registro de usuario
router.post("/register", async (req, res) => {
  const { nombre, correo, contrasena } = req.body;

  console.log("📥 Datos recibidos para registro:", req.body);

  try {
    // Verificar campos requeridos
    if (!nombre || !correo || !contrasena) {
      console.error("❌ Faltan campos requeridos");
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    // Buscar usuario existente
    const existingUser = await User.findOne({ correo });
    if (existingUser) {
      return res.status(400).json({ message: "El usuario ya existe" });
    }

    // Hashear contraseña
    const hashedPassword = await bcrypt.hash(contrasena, 10);

    // Crear usuario nuevo
    const newUser = new User({ nombre, correo, contrasena: hashedPassword });
    await newUser.save();

    console.log("✅ Usuario registrado correctamente:", newUser);

    res.status(201).json({ message: "Usuario registrado", user: newUser });
  } catch (error) {
    console.error("💥 Error en registro:", error);
    res.status(500).json({ message: "Error interno", error: error.message });
  }
});

// Login de usuario
router.post("/login", async (req, res) => {
  const { correo, contrasena } = req.body;

  console.log("📥 Intento de login:", req.body);

  try {
    if (!correo || !contrasena) {
      return res.status(400).json({ message: "Correo y contraseña requeridos" });
    }

    const user = await User.findOne({ correo });
    if (!user) {
      console.warn("⚠️ Usuario no encontrado:", correo);
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    const isMatch = await bcrypt.compare(contrasena, user.contrasena);
    if (!isMatch) {
      console.warn("⚠️ Contraseña incorrecta para:", correo);
      return res.status(401).json({ message: "Contraseña incorrecta" });
    }

    console.log("✅ Login exitoso:", correo);
    res.json(user);
  } catch (error) {
    console.error("💥 Error en login:", error);
    res.status(500).json({ message: "Error interno", error: error.message });
  }
});

module.exports = router;
