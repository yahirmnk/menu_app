const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcrypt");

// Registro de usuario
router.post("/register", async (req, res) => {
  const { nombre, email, contrasena } = req.body;

  console.log("📥 Datos recibidos para registro:", req.body);

  try {
    // Verificar campos requeridos
    if (!nombre || !email || !contrasena) {
      console.error("❌ Faltan campos requeridos");
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    // Buscar usuario existente
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      console.warn("⚠️ El usuario ya existe:", email);
      return res.status(400).json({ message: "El usuario ya existe" });
    }

    // Hashear contraseña
    const hashedPassword = await bcrypt.hash(contrasena, 10);

    // Crear usuario nuevo
    const newUser = new User({ nombre, email, contrasena: hashedPassword });
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
  const { email, contrasena } = req.body;

  console.log("📥 Intento de login:", req.body);

  try {
    if (!email || !contrasena) {
      return res.status(400).json({ message: "Email y contraseña requeridos" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      console.warn("⚠️ Usuario no encontrado:", email);
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    const isMatch = await bcrypt.compare(contrasena, user.contrasena);
    if (!isMatch) {
      console.warn("⚠️ Contraseña incorrecta para:", email);
      return res.status(401).json({ message: "Contraseña incorrecta" });
    }

    console.log("✅ Login exitoso:", email);
    res.json(user);
  } catch (error) {
    console.error("💥 Error en login:", error);
    res.status(500).json({ message: "Error interno", error: error.message });
  }
});

module.exports = router;
