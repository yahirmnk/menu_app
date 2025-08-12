const mongoose = require("mongoose");

const dietSchema = new mongoose.Schema({
  nombre: String,
  tag: String
});

module.exports = mongoose.model("Diet", dietSchema, "dietas");
