const express = require("express");
const router = express.Router();
const streakController = require("../controllers/streakController");

router.post("/check-in", streakController.checkIn);
router.get("/streak", streakController.getStreak);
router.get("/history", streakController.getHistory);


module.exports = router;
