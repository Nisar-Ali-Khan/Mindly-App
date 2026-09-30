import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_button.dart';
import '../../auth/screens/signup_screen.dart';

class PrivacyInfoScreen extends StatelessWidget {
  const PrivacyInfoScreen({super.key});

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
                  const Text('Step 2 of 2', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
                      'Your Privacy Matters',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.deepPlum,
                            fontSize: 26,
                          ),
                    ),
                    const SizedBox(height: 32),
                    _buildPrivacyItem(
                      context,
                      Icons.lock_outline,
                      'Your journal is private',
                      'Your parent or guardian cannot read your private journal entries. This is your space.',
                    ),
                    const SizedBox(height: 24),
                    _buildPrivacyItem(
                      context,
                      Icons.visibility_outlined,
                      'What is shared?',
                      'Only general wellbeing trends (like if you\'re checking in regularly) are visible to your connected parent.',
                    ),
                    const SizedBox(height: 24),
                    _buildPrivacyItem(
                      context,
                      Icons.security_outlined,
                      'You are in control',
                      'You can disconnect from a parent or change your sharing settings at any time.',
                    ),
                    const Spacer(),
                    AppButton(
                      text: 'I Understand',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
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

  Widget _buildPrivacyItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.amber.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.amber),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.deepPlum)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
