import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../src/app_constants.dart';
import '../view_models/calendar_view_model.dart';
import '../view_models/streak_view_model.dart';
import '../widgets/legend_item.dart';
import '../widgets/stat_item.dart';

class CalendarView extends StatefulWidget {
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarViewModel>().loadCalendarData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          AppConstants.checkInCalendar,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<CalendarViewModel>(
        builder: (context, calendarVM, child) {
          if (calendarVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (calendarVM.state == ViewState.error) {
            return Center(
              child: Text(
                '${AppConstants.error}${calendarVM.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return _buildCalendarContent(calendarVM);
        },
      ),
    );
  }

  Widget _buildCalendarContent(CalendarViewModel calendarVM) {
    return Column(
      children: [
        // Legend
        _buildLegend(),

        // Calendar
        _buildCalendar(calendarVM),

        // Stats summary
        _buildStatsSummary(calendarVM),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LegendItem(
            color: Colors.green,
            label: AppConstants.checkIn,
            icon: Icons.check_circle,
          ),
          LegendItem(
            color: Colors.red,
            label: AppConstants.missed,
            icon: Icons.cancel,
          ),
          LegendItem(
            color: Colors.grey.shade300,
            label: AppConstants.noData,
            icon: Icons.circle_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(CalendarViewModel calendarVM) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TableCalendar<DateTime>(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) => _buildCalendarDay(calendarVM, day),
            todayBuilder: (context, day, focusedDay) => _buildTodayCell(calendarVM, day),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            formatButtonTextStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildCalendarDay(CalendarViewModel calendarVM, DateTime day) {
    if (calendarVM.isCheckInDay(day)) {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (calendarVM.isMissedDay(day)) {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          border: Border.all(color: Colors.red, width: 2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget _buildTodayCell(CalendarViewModel calendarVM, DateTime day) {
    if (calendarVM.isCheckInDay(day)) {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 3),
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          border: Border.all(color: Colors.orange, width: 2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildStatsSummary(CalendarViewModel calendarVM) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            value: calendarVM.checkInDays.length.toString(),
            label: AppConstants.totalCheckIns,
            color: Colors.green,
          ),
          StatItem(
            value: calendarVM.missedDays.length.toString(),
            label: AppConstants.missedDays,
            color: Colors.red,
          ),
          StatItem(
            value: '${calendarVM.successRate.toStringAsFixed(0)}%',
            label: AppConstants.successRate,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}