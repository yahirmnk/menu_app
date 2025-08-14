const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcrypt");

// Registro de usuario
router.post("/register", async (req, res) => {
  let { nombre, correo, contrasena } = req.body;
  correo = String(correo || "").trim().toLowerCase();

  console.log("📥 Datos recibidos para registro:", { nombre, correo, contrasena });

  try {
    if (!nombre || !correo || !contrasena) {
      console.error("❌ Faltan campos requeridos");
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    const existingUser = await User.findOne({ correo });
    if (existingUser) {
      console.warn("⚠️ Usuario ya existe:", correo);
      return res.status(400).json({ message: "El usuario ya existe" });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);
    const newUser = new User({ 
      nombre, 
      correo, 
      contrasena: hashedPassword 
    });
    
    await newUser.save();

    console.log("✅ Usuario registrado correctamente:", newUser);

    const userResponse = newUser.toObject();
    delete userResponse.contrasena;
    userResponse._id = newUser._id.toString();

    res.status(201).json({
      message: "Usuario registrado correctamente",
      user: userResponse
    });

  } catch (error) {
    console.error("💥 Error en registro:", error);
    res.status(500).json({ message: "Error interno", error: error.message });
  }
});

// Login de usuario
router.post("/login", async (req, res) => {
  let { correo, contrasena } = req.body;
  correo = String(correo || "").trim().toLowerCase();

  console.log("📥 Intento de login:", { correo, contrasena });

  try {
    if (!correo || !contrasena) {
      console.error("❌ Faltan credenciales");
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

    const userResponse = user.toObject();
    delete userResponse.contrasena;
    userResponse._id = user._id.toString();

    res.json({
      message: "Login exitoso",
      user: userResponse
    });

  } catch (error) {
    console.error("💥 Error en login:", error);
    res.status(500).json({ message: "Error interno", error: error.message });
  }
});

module.exports = router;