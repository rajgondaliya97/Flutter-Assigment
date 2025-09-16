class CalendarData {
  final List<DateTime> checkInDays;
  final List<String> missedDays;

  CalendarData({
    required this.checkInDays,
    required this.missedDays,
  });

  CalendarData copyWith({
    List<DateTime>? checkInDays,
    List<String>? missedDays,
  }) {
    return CalendarData(
      checkInDays: checkInDays ?? this.checkInDays,
      missedDays: missedDays ?? this.missedDays,
    );
  }

  double get successRate {
    final total = checkInDays.length + missedDays.length;
    if (total == 0) return 0;
    return (checkInDays.length / total) * 100;
  }

  /// ✅ Convert from JSON
  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      checkInDays: (json['checkInDays'] as List<dynamic>?)
          ?.map((e) => DateTime.tryParse(e as String)!)
          .toList() ??
          [],
      missedDays: (json['missedDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  /// ✅ Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'checkInDays': checkInDays.map((e) => e.toIso8601String()).toList(),
      'missedDays': missedDays,
    };
  }
}
