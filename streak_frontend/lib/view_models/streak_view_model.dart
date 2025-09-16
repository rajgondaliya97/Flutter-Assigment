import 'package:flutter/foundation.dart';
import '../model/streak_model.dart';
import '../services/api_service.dart';

enum ViewState { idle, loading, error }

class StreakViewModel extends ChangeNotifier {
  StreakData? _streakData;
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  bool _hasCheckedInToday = false;

  // Getters
  StreakData? get streakData => _streakData;

  ViewState get state => _state;

  String get errorMessage => _errorMessage;

  bool get hasCheckedInToday => _hasCheckedInToday;

  bool get isLoading => _state == ViewState.loading;

  int get currentStreak => _streakData?.currentStreak ?? 0;

  int get longestStreak => _streakData?.longestStreak ?? 0;

  int get totalCheckIns => _streakData?.totalCheckIns ?? 0;

  DateTime? get lastCheckIn => _streakData?.lastCheckIn;

  // Business logic
  bool shouldShowReminder() {
    final now = DateTime.now();
    return now.hour >= 20 && !_hasCheckedInToday;
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void _checkIfCheckedInToday() {
    if (_streakData?.lastCheckIn == null) {
      _hasCheckedInToday = false;
      return;
    }

    final today = DateTime.now();
    final lastCheckIn = _streakData!.lastCheckIn!;

    _hasCheckedInToday =
        lastCheckIn.year == today.year &&
        lastCheckIn.month == today.month &&
        lastCheckIn.day == today.day;
  }

  Future<void> loadStreakData() async {
    _setState(ViewState.loading);
    _errorMessage = '';

    try {
      _streakData = await ApiService.getStreakData();
      _checkIfCheckedInToday();
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<CheckInResponse> checkIn() async {
    if (_hasCheckedInToday) {
      return CheckInResponse(
        success: false,
        message: 'Already checked in today!',
      );
    }
    try {
      final response = await ApiService.checkIn();
      if (response.success) {
        // Reload streak data after successful check-in
        final data = StreakData(
          currentStreak: response.currentStreak ?? 0,
          longestStreak: response.longestStreak ?? 0,
          totalCheckIns: response.totalCheckIns ?? 0,
          lastCheckIn: response.lastCheckIn != null
              ? DateTime.tryParse(response.lastCheckIn.toString())
              : null,
        );
        _streakData = data;
        _checkIfCheckedInToday();
        _setState(ViewState.idle);
      }

      return response;
    } catch (e) {
      return CheckInResponse(success: false, message: e.toString());
    }
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
