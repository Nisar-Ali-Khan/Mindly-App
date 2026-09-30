import 'package:flutter/material.dart';
import 'package:mindly/features/teen/home/screens/home_screen.dart';
import 'package:mindly/features/teen/journal/screens/journal_list_screen.dart';
import 'package:mindly/features/teen/activities/screens/activities_screen.dart';
import 'package:mindly/features/teen/insights/screens/insights_screen.dart';
import 'package:mindly/features/teen/profile/screens/profile_screen.dart';

class TeenMainScreen extends StatefulWidget {
  const TeenMainScreen({super.key});

  @override
  State<TeenMainScreen> createState() => _TeenMainScreenState();
}

class _TeenMainScreenState extends State<TeenMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TeenHomeScreen(),
    const JournalListScreen(),
    const ActivitiesScreen(),
    const InsightsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.edit_note_outlined), selectedIcon: Icon(Icons.edit_note), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa), label: 'Activities'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
