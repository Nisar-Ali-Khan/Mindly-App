import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/models/mood_model.dart';
import 'package:mindly/repositories/mood_repository.dart';
import '../../../../repositories/parent_repository.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../../widgets/app_card.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const Scaffold(body: Center(child: Text('Login required')));

    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How is your teen doing?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32),
            if (user.connectedTeenUid == null)
              _buildNoConnection(context, ref, user.id, textColor)
            else
              _buildSummary(context, ref, user.connectedTeenUid!, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnection(BuildContext context, WidgetRef ref, String parentId, Color textColor) {
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.link_off, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No teen connected yet.', style: TextStyle(color: textColor)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final code = await ref.read(parentRepositoryProvider).generateConnectionCode(parentId);
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Connection Code'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Share this code with your teen:'),
                        const SizedBox(height: 16),
                        Text(
                          code,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
                    ],
                  ),
                );
              }
            },
            child: const Text('Generate Connection Code'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, WidgetRef ref, String teenUid, Color textColor) {
    final moodStream = ref.watch(moodRepositoryProvider).getMoodEntries(teenUid);

    return StreamBuilder<List<MoodEntry>>(
      stream: moodStream,
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];
        final now = DateTime.now();
        final past7Days = entries.where((e) => now.difference(e.createdAt).inDays <= 7).toList();

        final checkInsThisWeek = past7Days.length;
        final hasEntries = past7Days.isNotEmpty;

        return Column(
          children: [
            AppCard(
              color: AppColors.sage.withValues(alpha: 0.2),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.sage, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wellbeing Trend', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 2),
                        Text(
                          hasEntries ? 'Active Check-ins Recorded' : 'Awaiting Check-ins',
                          style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Check-ins this week', style: TextStyle(color: textColor)),
                      Text('$checkInsThisWeek / 7 days', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppCard(
              color: AppColors.amber.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.support_agent_rounded, color: AppColors.amber),
                      const SizedBox(width: 8),
                      Text('Support Suggestion', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasEntries
                        ? 'Check in with your teen gently about their day. They have been keeping up with their Mindly check-ins!'
                        : 'Encourage your teen to complete a 1-minute daily check-in on Mindly.',
                    style: TextStyle(color: textColor.withValues(alpha: 0.9), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '🔒 Privacy Note: Private journal entries and notes are strictly hidden from parent accounts. You only see wellbeing activity trends.',
              style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.5), height: 1.4),
            ),
          ],
        );
      },
    );
  }
}
