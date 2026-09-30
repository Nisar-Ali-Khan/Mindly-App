import 'package:flutter/material.dart';
import '../../../../models/activity_model.dart';
import '../../../../widgets/app_card.dart';
import 'breathing_activity_screen.dart';
import 'grounding_activity_screen.dart';
import 'worry_dump_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: appActivities.length,
        itemBuilder: (context, index) {
          final activity = appActivities[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              color: activity.color.withValues(alpha: 0.1),
              onTap: () {
                if (activity.id == 'breathing') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BreathingActivityScreen()),
                  );
                } else if (activity.id == 'grounding') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GroundingActivityScreen()),
                  );
                } else if (activity.id == 'worry-dump') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WorryDumpScreen()),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: activity.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(activity.icon, color: activity.color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          activity.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${activity.durationMinutes}m',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
