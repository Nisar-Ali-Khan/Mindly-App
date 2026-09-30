import 'package:flutter/material.dart';
import '../../teen/activities/screens/breathing_activity_screen.dart';
import '../../../widgets/app_card.dart';

class SafetyCenterScreen extends StatelessWidget {
  const SafetyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need a moment?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            const Text('We\'re here to help you feel safe and supported.'),
            const SizedBox(height: 32),
            AppCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BreathingActivityScreen()),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.air, size: 32, color: Color(0xFFA98BC0)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I need help calming down', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Start a 2-minute breathing exercise'),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              onTap: () {
                // Show grounding info or activity
              },
              child: const Row(
                children: [
                  Icon(Icons.spa, size: 32, color: Color(0xFF9DB7A5)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Grounding exercise', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('5-4-3-2-1 technique to reset'),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Talk to someone',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AppCard(
              child: const Row(
                children: [
                  Icon(Icons.person_outline, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trusted Adult', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Reach out to someone you trust.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              color: Colors.red.withOpacity(0.05),
              child: const Row(
                children: [
                  Icon(Icons.phone_in_talk, size: 32, color: Colors.red),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emergency Resources', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        Text('Helplines and professional support.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Center(
              child: Text(
                'Mindly is not an emergency service. If you are in immediate danger, please call emergency services.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
