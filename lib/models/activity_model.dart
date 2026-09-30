import 'package:flutter/material.dart';

enum ActivityCategory { calm, mind, feel, reset }

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityCategory category;
  final int durationMinutes;
  final IconData icon;
  final Color color;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    required this.icon,
    required this.color,
  });
}

final List<Activity> appActivities = [
  const Activity(
    id: 'breathing',
    title: '2-Minute Breathing',
    description: 'A quick reset to help you find your calm.',
    category: ActivityCategory.calm,
    durationMinutes: 2,
    icon: Icons.air,
    color: Color(0xFFA98BC0),
  ),
  const Activity(
    id: 'grounding',
    title: '5-4-3-2-1 Grounding',
    description: 'Connect with your senses to reduce anxiety.',
    category: ActivityCategory.calm,
    durationMinutes: 5,
    icon: Icons.spa,
    color: Color(0xFF9DB7A5),
  ),
  const Activity(
    id: 'worry-dump',
    title: 'Worry Dump',
    description: 'Get those thoughts out of your head and onto the page.',
    category: ActivityCategory.mind,
    durationMinutes: 5,
    icon: Icons.delete_outline,
    color: Color(0xFFE8A6B4),
  ),
];
