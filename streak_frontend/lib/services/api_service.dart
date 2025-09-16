import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upsquaretask/src/app_urls.dart';
import '../model/calendar_data.dart';
import '../model/streak_model.dart';

class ApiService {

  static Future<StreakData> getStreakData() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.streakUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StreakData.fromJson(data);
      } else {
        throw Exception('Failed to load streak data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<CheckInResponse> checkIn() async {
    try {
      final response = await http.post(
        Uri.parse(AppUrls.checkInUrl),
      );
      final data = json.decode(response.body);
       return CheckInResponse.fromJson(data);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<CalendarData> getCheckInHistory() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.historyUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CalendarData.fromJson(data);
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}