import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/models/mood_model.dart';
import 'package:mindly/models/journal_model.dart';
import 'package:mindly/repositories/mood_repository.dart';
import 'package:mindly/repositories/journal_repository.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';

class UserStats {
  final int streak;
  final int level;
  final int totalXP;
  final int totalCheckIns;
  final int totalJournals;

  const UserStats({
    required this.streak,
    required this.level,
    required this.totalXP,
    required this.totalCheckIns,
    required this.totalJournals,
  });

  static const empty = UserStats(
    streak: 0,
    level: 1,
    totalXP: 0,
    totalCheckIns: 0,
    totalJournals: 0,
  );
}

final userStatsProvider = StreamProvider<UserStats>((ref) {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return Stream.value(UserStats.empty);

  final moodStream = ref.watch(moodRepositoryProvider).getMoodEntries(user.id);
  final journalStream = ref.watch(journalRepositoryProvider).getJournalEntries(user.id);

  return moodStream.asyncMap((moods) async {
    final journals = await journalStream.first.catchError((_) => <JournalEntry>[]);
    return calculateStats(moods, journals);
  });
});

UserStats calculateStats(List<MoodEntry> moods, List<JournalEntry> journals) {
  if (moods.isEmpty && journals.isEmpty) {
    return UserStats.empty;
  }

  // 1. Calculate Streak from check-ins
  int streak = 0;
  if (moods.isNotEmpty) {
    final dates = moods
        .map((e) => DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dates.contains(today) || dates.contains(yesterday)) {
      DateTime checkDate = dates.contains(today) ? today : yesterday;
      for (final date in dates) {
        if (date.isAtSameMomentAs(checkDate)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (date.isBefore(checkDate)) {
          break;
        }
      }
    }
  }

  // 2. Calculate XP and Level
  final checkInXP = moods.length * 10;
  final journalXP = journals.length * 15;
  final totalXP = checkInXP + journalXP;
  final level = (totalXP / 50).floor() + 1;

  return UserStats(
    streak: streak,
    level: level,
    totalXP: totalXP,
    totalCheckIns: moods.length,
    totalJournals: journals.length,
  );
}
