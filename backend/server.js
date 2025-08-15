require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

// Importar rutas
const recipeRoutes = require("./routes/recipes");
const userRoutes = require("./routes/users");
const dietRoutes = require("./routes/diets"); 
const adminRecipeRoutes = require("./routes/admin_recipes");

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());
//RUTA RAIZ
app.get("/", (req, res) => res.json({ ok: true, env: process.env.NODE_ENV || "dev" }));
// Rutas
app.use("/api/recipes", recipeRoutes);
app.use("/api/users", userRoutes);
app.use("/api/diets", dietRoutes);
app.use("/api/admin/recipes", adminRecipeRoutes); 

// Conexión a MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log(" Conectado a MongoDB Atlas");
    app.listen(process.env.PORT, "0.0.0.0", () => {
      console.log(`Servidor corriendo en http://0.0.0.0:${process.env.PORT}`);
    });
  })
  .catch(err => console.error(" Error de conexión:", err));
