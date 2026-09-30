import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/repositories/journal_repository.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';
import 'package:mindly/features/teen/journal/screens/journal_editor_screen.dart';
import 'package:mindly/widgets/app_card.dart';
import 'package:mindly/models/journal_model.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login')));

    final journalEntriesStream = ref.watch(journalRepositoryProvider).getJournalEntries(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Private Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {}, // Show privacy info
          ),
        ],
      ),
      body: StreamBuilder<List<JournalEntry>>(
        stream: journalEntriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_note, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Your thoughts can start here.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final entries = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => JournalEditorScreen(entry: entry),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title.isEmpty ? 'Untitled' : entry.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          if (entry.mood.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(entry.mood, style: const TextStyle(fontSize: 12)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const JournalEditorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
