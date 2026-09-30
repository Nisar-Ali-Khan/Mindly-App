import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_button.dart';

class GroundingActivityScreen extends StatefulWidget {
  const GroundingActivityScreen({super.key});

  @override
  State<GroundingActivityScreen> createState() => _GroundingActivityScreenState();
}

class _GroundingActivityScreenState extends State<GroundingActivityScreen> {
  int _step = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': '5 Things You Can SEE',
      'icon': Icons.visibility_rounded,
      'desc': 'Look around you. Notice 5 objects near you (e.g., a clock, a chair, a pen).',
      'count': 5,
    },
    {
      'title': '4 Things You Can TOUCH',
      'icon': Icons.touch_app_rounded,
      'desc': 'Pay attention to 4 physical sensations (e.g., your feet on the floor, your shirt texture).',
      'count': 4,
    },
    {
      'title': '3 Things You Can HEAR',
      'icon': Icons.hearing_rounded,
      'desc': 'Listen closely. Identify 3 subtle sounds in your environment (e.g., hum of a fan, distant cars).',
      'count': 3,
    },
    {
      'title': '2 Things You Can SMELL',
      'icon': Icons.air_rounded,
      'desc': 'Notice 2 scents around you (e.g., soap, fresh air, coffee, or your sleeve).',
      'count': 2,
    },
    {
      'title': '1 Thing You Can TASTE',
      'icon': Icons.restaurant_rounded,
      'desc': 'Notice 1 taste in your mouth right now (or take a sip of water).',
      'count': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final current = _steps[_step];

    return Scaffold(
      backgroundColor: AppColors.sage.withValues(alpha: 0.15),
      appBar: AppBar(
        title: Text('Grounding (${_step + 1}/5)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_step + 1) / 5,
                backgroundColor: AppColors.sage.withValues(alpha: 0.3),
                color: AppColors.sage,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.sage.withValues(alpha: 0.2),
                      child: Icon(current['icon'] as IconData, size: 36, color: AppColors.sage),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      current['title'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.deepPlum,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      current['desc'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                text: _step == 4 ? 'Complete Exercise' : 'Next Step',
                color: AppColors.sage,
                onPressed: () {
                  if (_step < 4) {
                    setState(() => _step++);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Great job! You are grounded and present.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
