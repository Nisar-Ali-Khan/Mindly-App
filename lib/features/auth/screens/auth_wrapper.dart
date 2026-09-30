import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../onboarding/screens/onboarding_screen.dart';
import '../controllers/auth_controller.dart';
import '../../teen/home/screens/main_screen.dart';
import '../../parent/dashboard/screens/parent_dashboard_screen.dart';
import '../../../models/user_model.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const OnboardingScreen();
        }
        
        if (user.role == UserRole.teen) {
          return const TeenMainScreen();
        } else {
          return const ParentDashboardScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
