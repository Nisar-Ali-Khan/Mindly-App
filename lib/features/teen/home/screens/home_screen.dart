import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_card.dart';
import 'package:mindly/widgets/app_button.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';
import 'package:mindly/features/teen/checkin/screens/checkin_screen.dart';
import 'package:mindly/features/safety/screens/safety_center_screen.dart';
import 'package:mindly/repositories/stats_repository.dart';
import 'package:mindly/repositories/mood_repository.dart';
import 'package:mindly/models/mood_model.dart';
import '../widgets/weekly_mood_chart.dart';
import '../widgets/daily_affirmation_card.dart';

class TeenHomeScreen extends ConsumerWidget {
  const TeenHomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final statsAsync = ref.watch(userStatsProvider);
    final moodStream = user != null
        ? ref.watch(moodRepositoryProvider).getMoodEntries(user.id)
        : Stream<List<MoodEntry>>.value([]);

    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()},',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${user?.displayName ?? 'Friend'} 👋',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.security, color: primaryColor),
                        tooltip: 'Safety Center',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SafetyCenterScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: primaryColor),
                        tooltip: 'Logout',
                        onPressed: () {
                          ref.read(authControllerProvider.notifier).signOut();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              
              // Daily Check-in CTA Card
              AppCard(
                color: primaryColor.withValues(alpha: 0.15),
                child: Column(
                  children: [
                    Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Quick Check-in',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CheckinScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Daily Affirmation Card
              const DailyAffirmationCard(),

              const SizedBox(height: 28),

              // Real Dynamic Streak & Level Bar
              statsAsync.when(
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        color: AppColors.dustyRose.withValues(alpha: 0.25),
                        child: Column(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: AppColors.dustyRose, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              '${stats.streak} Day${stats.streak == 1 ? '' : 's'} Streak',
                              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppCard(
                        color: AppColors.sage.withValues(alpha: 0.25),
                        child: Column(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.sage, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              'Level ${stats.level}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox(height: 70, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                error: (_, __) => Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        color: AppColors.dustyRose.withValues(alpha: 0.25),
                        child: Text(
                          '0 Days Streak',
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppCard(
                        color: AppColors.sage.withValues(alpha: 0.25),
                        child: Text(
                          'Level 1',
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Weekly Mood Chart from real Firestore stream
              Text(
                'Weekly Mood Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              AppCard(
                child: StreamBuilder<List<MoodEntry>>(
                  stream: moodStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 140,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final entries = snapshot.data ?? [];
                    return WeeklyMoodChart(entries: entries);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
