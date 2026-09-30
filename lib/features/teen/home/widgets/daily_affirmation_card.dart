import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_card.dart';

class DailyAffirmationCard extends StatefulWidget {
  const DailyAffirmationCard({super.key});

  @override
  State<DailyAffirmationCard> createState() => _DailyAffirmationCardState();
}

class _DailyAffirmationCardState extends State<DailyAffirmationCard> {
  final List<String> _affirmations = [
    "I am capable of handling whatever today brings.",
    "My feelings are valid, and it is okay to take a break.",
    "I choose peace over perfection.",
    "I am growing at my own pace, and that is enough.",
    "I treat myself with kindness and self-compassion.",
    "Small steps every day lead to big progress.",
    "I am allowed to set boundaries to protect my peace.",
  ];

  int _currentIndex = 0;

  void _nextAffirmation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _affirmations.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return AppCard(
      color: AppColors.amber.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny_rounded, color: AppColors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'DAILY AFFIRMATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh_rounded, size: 20, color: textColor),
                tooltip: 'New Affirmation',
                onPressed: _nextAffirmation,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${_affirmations[_currentIndex]}"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.4,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
