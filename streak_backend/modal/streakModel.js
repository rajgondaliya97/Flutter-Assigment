class StreakModel {
  constructor() {
    this.currentStreak = 0;
    this.longestStreak = 0;
    this.lastCheckIn = null;
    this.totalCheckIns = 0;  
    this.checkIns = new Set();
  }

  formatDate(date) {
    return date.toISOString().split("T")[0];
  }
}

module.exports = new StreakModel();
