const express = require("express");
const bodyParser = require("body-parser");
const streakRoutes = require("./routes/streakRoutes");

const app = express();
app.use(bodyParser.json());

// Routes
app.use("/", streakRoutes);

// Start server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
