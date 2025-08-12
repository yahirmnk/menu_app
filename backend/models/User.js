const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  nombre: { type: String, required: true },
  correo: { type: String, required: true, unique: true },
  contrasena: { type: String, required: true }
}, { collection: "usuarios" }); 

// Forzar uso de la colección "usuarios"
module.exports = mongoose.model("User", userSchema, "usuarios");
