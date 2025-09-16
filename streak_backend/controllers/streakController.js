const streakData = require("../modal/streakModel");

// POST /check-in
exports.checkIn = (req, res) => {
  const today = streakData.formatDate(new Date());

  if (streakData.checkIns.has(today)) {
    return res.json({
      message: "Already checked in today ✅",
      success: false,
      currentStreak: streakData.currentStreak,
      longestStreak: streakData.longestStreak,
      totalCheckIns: streakData.totalCheckIns, // 👈 include
      lastCheckIn: streakData.lastCheckIn,
    });
  }

  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayStr = streakData.formatDate(yesterday);

  if (streakData.lastCheckIn === yesterdayStr) {
    streakData.currentStreak += 1;
  } else {
    streakData.currentStreak = 1;
  }

  streakData.longestStreak = Math.max(
    streakData.longestStreak,
    streakData.currentStreak
  );

  streakData.checkIns.add(today);
  streakData.lastCheckIn = today;
  streakData.totalCheckIns += 1; // 👈 increment

  res.json({
    message: "Check-in successful 🎉",
    success: true,
    currentStreak: streakData.currentStreak,
    longestStreak: streakData.longestStreak,
    totalCheckIns: streakData.totalCheckIns,
    lastCheckIn: streakData.lastCheckIn,
  });
};



// GET /streak
exports.getStreak = (req, res) => {
  res.json({
    currentStreak: streakData.currentStreak,
    longestStreak: streakData.longestStreak,
    totalCheckIns: streakData.totalCheckIns, // 👈 include
    lastCheckIn: streakData.lastCheckIn,
  });
};

// GET /history
exports.getHistory = (req, res) => {
  const today = new Date();
  let missedDays = [];
  let checkInDays = [];

  for (let i = 0; i < 30; i++) { // last 30 days
    const date = new Date();
    date.setDate(today.getDate() - i);
    const dateStr = streakData.formatDate(date);

    if (streakData.checkIns.has(dateStr)) {
      checkInDays.push(dateStr);
    } else {
      missedDays.push(dateStr);
    }
  }

  res.json({
    missedDays,
    checkInDays,
  });
};

