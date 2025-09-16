
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCheckIn;
  final int totalCheckIns;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCheckIn,
    required this.totalCheckIns,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.parse(json['lastCheckIn'])
          : null,
      totalCheckIns: json['totalCheckIns'] ?? 0,
    );
  }

  StreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckIn,
    int? totalCheckIns,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
    );
  }
}
class CheckInResponse {
  final bool success;
  final String message;
  final int? currentStreak;
  final int? longestStreak;
  final int? totalCheckIns;
  final DateTime? lastCheckIn;

  CheckInResponse({
    required this.success,
    required this.message,
    this.currentStreak,
    this.longestStreak,
    this.totalCheckIns,
    this.lastCheckIn,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      totalCheckIns: json['totalCheckIns'],
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.tryParse(json['lastCheckIn'])
          : null,
    );
  }
}

