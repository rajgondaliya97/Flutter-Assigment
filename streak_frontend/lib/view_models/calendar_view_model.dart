import 'package:flutter/foundation.dart';
import 'package:upsquaretask/view_models/streak_view_model.dart';
import '../model/calendar_data.dart';
import '../services/api_service.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarData? _calendarData;
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  // Getters
  CalendarData? get calendarData => _calendarData;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;

  List<DateTime> get checkInDays => _calendarData?.checkInDays ?? [];
  List<String> get missedDays => _calendarData?.missedDays ?? [];
  double get successRate => _calendarData?.successRate ?? 0;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  bool isCheckInDay(DateTime day) {
    return checkInDays.any((checkInDay) =>
    checkInDay.year == day.year &&
        checkInDay.month == day.month &&
        checkInDay.day == day.day);
  }

  bool isMissedDay(DateTime day) {
    final dayStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return missedDays.contains(dayStr);
  }

  Future<void> loadCalendarData() async {
    _setState(ViewState.loading);
    _errorMessage = '';

    try {
      _calendarData = await ApiService.getCheckInHistory();
      debugPrint('_calender Data >>>> $_calendarData');
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}
