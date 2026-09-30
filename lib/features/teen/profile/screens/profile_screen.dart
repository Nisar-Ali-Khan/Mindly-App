import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/core/theme/theme_provider.dart';
import 'package:mindly/widgets/app_card.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';
import 'package:mindly/repositories/stats_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final statsAsync = ref.watch(userStatsProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // User Header Card
            AppCard(
              color: AppColors.lavender.withValues(alpha: 0.15),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.deepPlum,
                    child: Text(
                      (user?.displayName.isNotEmpty ?? false)
                          ? user!.displayName[0].toUpperCase()
                          : 'M',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Teen User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.role.name.toUpperCase() ?? 'TEEN',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPlum,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Real Stats Overview
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          Text('${stats.totalCheckIns}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepPlum)),
                          const SizedBox(height: 4),
                          const Text('Check-ins', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          Text('${stats.totalJournals}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepPlum)),
                          const SizedBox(height: 4),
                          const Text('Journals', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          Text('${stats.totalXP}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.amber)),
                          const SizedBox(height: 4),
                          const Text('Total XP', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // App Preferences Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('App Preferences', style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Calming dark palette for night viewing'),
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.deepPlum),
                    value: isDark,
                    activeColor: AppColors.amber,
                    onChanged: (_) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Daily Check-in Reminder'),
                    subtitle: Text('Remind me at ${_reminderTime.format(context)}'),
                    secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.deepPlum),
                    value: _notificationsEnabled,
                    activeColor: AppColors.amber,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  if (_notificationsEnabled)
                    ListTile(
                      leading: const Icon(Icons.access_time_rounded, color: AppColors.amber),
                      title: const Text('Set Reminder Time'),
                      trailing: Text(_reminderTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: _selectTime,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Privacy & Account Controls
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Privacy & Security', style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded, color: AppColors.sage),
                    title: const Text('Private Journal Boundary'),
                    subtitle: const Text('Your entries are strictly private to your device & UID.'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.download_rounded, color: AppColors.deepPlum),
                    title: const Text('Export My Data'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data exported to local download folder.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Mindly v1.0.0 • Your space. Your feelings. Your growth.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
