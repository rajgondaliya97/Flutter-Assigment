import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/app_constants.dart';
import '../view_models/streak_view_model.dart';
import '../widgets/check_in_button.dart';
import '../widgets/remainder_card.dart';
import '../widgets/stat_card.dart';
import 'calendar_view.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreakViewModel>().loadStreakData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          AppConstants.streakTracker,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarView()),
              );
            },
          ),
        ],
      ),
      body: Consumer<StreakViewModel>(
        builder: (context, streakVM, child) {
          return RefreshIndicator(
            onRefresh: () => streakVM.loadStreakData(),
            child: _buildBody(streakVM),
          );
        },
      ),
    );
  }

  Widget _buildBody(StreakViewModel streakVM) {
    if (streakVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (streakVM.state == ViewState.error) {
      return _buildErrorWidget(streakVM);
    }

    return _buildContent(streakVM);
  }

  Widget _buildErrorWidget(StreakViewModel streakVM) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            AppConstants.errorLoadingData,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            streakVM.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => streakVM.loadStreakData(),
            child: const Text(AppConstants.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StreakViewModel streakVM) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Main streak display
          _buildStreakDisplay(streakVM),

          // Stats cards
          _buildStatsCards(streakVM),

          const SizedBox(height: 20),
          // Last check-in info
          if (streakVM.lastCheckIn != null) _buildLastCheckInInfo(streakVM),

          const SizedBox(height: 30),

          // Reminder card
          if (streakVM.shouldShowReminder()) _buildReminderCard(),

          const SizedBox(height: 20),

          // Check-in button
          const CheckInButton(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStreakDisplay(StreakViewModel streakVM) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            '${streakVM.currentStreak}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            AppConstants.dayStreak,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(StreakViewModel streakVM) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: AppConstants.longestStreak,
              value: '${streakVM.longestStreak}',
              icon: Icons.emoji_events,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: AppConstants.totalCheckIns,
              value: '${streakVM.totalCheckIns}',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastCheckInInfo(StreakViewModel streakVM) {

    return Container(
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
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.grey.shade600),
          const SizedBox(width: 12),

          Text(
            '${AppConstants.lastCheckIn}${streakVM.lastCheckIn != null ? DateFormat('dd/MM/yyyy').format(streakVM.lastCheckIn!) : " "}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Consumer<StreakViewModel>(
      builder: (context, streakVM, child) {
        return ReminderCard(
          onCheckIn: () async {
            final response = await streakVM.checkIn();
            if (response.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }
}
