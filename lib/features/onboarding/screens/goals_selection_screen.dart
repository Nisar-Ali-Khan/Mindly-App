import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_button.dart';
import 'privacy_info_screen.dart';

class GoalsSelectionScreen extends StatefulWidget {
  const GoalsSelectionScreen({super.key});

  @override
  State<GoalsSelectionScreen> createState() => _GoalsSelectionScreenState();
}

class _GoalsSelectionScreenState extends State<GoalsSelectionScreen> {
  final List<String> _goals = [
    'Understanding my moods',
    'Managing stress',
    'Better sleep',
    'Confidence',
    'School pressure',
    'Friendships',
    'Family stress',
    'Building healthy routines',
    'Journaling',
    'Feeling more balanced',
  ];

  final List<String> _selectedGoals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.deepPlum),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text('Step 1 of 2', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What would you like help with?',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.deepPlum,
                            fontSize: 26,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Select all that apply to you.', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _goals.length,
                        itemBuilder: (context, index) {
                          final goal = _goals[index];
                          final isSelected = _selectedGoals.contains(goal);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedGoals.remove(goal);
                                  } else {
                                    _selectedGoals.add(goal);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.amber.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppColors.amber : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(goal, style: TextStyle(
                                      color: isSelected ? AppColors.deepPlum : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ))),
                                    if (isSelected)
                                      const Icon(Icons.check_circle, color: AppColors.amber),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Continue',
                      onPressed: _selectedGoals.isEmpty ? null : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PrivacyInfoScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
