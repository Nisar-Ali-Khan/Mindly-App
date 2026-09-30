import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_card.dart';
import 'package:mindly/models/mood_model.dart';
import 'package:mindly/repositories/mood_repository.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';
import 'package:mindly/features/teen/home/widgets/weekly_mood_chart.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  Map<String, int> _calculateTopInfluences(List<MoodEntry> entries) {
    final Map<String, int> counts = {};
    for (final entry in entries) {
      for (final reason in entry.reasons) {
        counts[reason] = (counts[reason] ?? 0) + 1;
      }
    }
    return counts;
  }

  String _generateObservation(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      return "Start logging your mood daily to receive personalized insights!";
    }

    final moodCounts = <String, int>{};
    for (final e in entries) {
      moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
    }

    final sortedMoods = moodCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topMood = sortedMoods.first.key;

    final reasons = _calculateTopInfluences(entries);
    if (reasons.isNotEmpty) {
      final sortedReasons = reasons.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      return "You logged feeling '$topMood' most frequently, often influenced by '${sortedReasons.first.key}'.";
    }

    return "You logged feeling '$topMood' most frequently this week.";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final moodStream = user != null
        ? ref.watch(moodRepositoryProvider).getMoodEntries(user.id)
        : Stream<List<MoodEntry>>.value([]);

    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Insights'),
        elevation: 0,
      ),
      body: StreamBuilder<List<MoodEntry>>(
        stream: moodStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data ?? [];
          final influences = _calculateTopInfluences(entries);
          final sortedInfluences = influences.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood Trends (7 Days)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: WeeklyMoodChart(entries: entries),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        entries.isEmpty
                            ? 'No entries logged yet.'
                            : 'Based on ${entries.length} recent check-in${entries.length == 1 ? '' : 's'}.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Top Mood Influences',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (sortedInfluences.isEmpty)
                  Text(
                    'Add reasons during check-in to track what influences your mood!',
                    style: TextStyle(color: textColor.withValues(alpha: 0.6)),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sortedInfluences.take(6).map((item) {
                      return InfluenceChip(
                        label: item.key,
                        count: item.value,
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 28),

                // Observation Insight Card
                AppCard(
                  color: AppColors.amber.withValues(alpha: 0.15),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.amber, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _generateObservation(entries),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Note: These observations are based strictly on your logged check-in entries and do not represent a clinical diagnosis.',
                  style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.5)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InfluenceChip extends StatelessWidget {
  final String label;
  final int count;

  const InfluenceChip({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label ($count)',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
