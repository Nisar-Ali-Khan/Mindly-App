import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mindly/models/journal_model.dart';
import 'package:mindly/repositories/journal_repository.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  final JournalEntry? entry;

  const JournalEditorScreen({super.key, this.entry});

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_contentController.text.isEmpty) return;

    setState(() => _isSaving = true);
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final entry = JournalEntry(
      id: widget.entry?.id ?? const Uuid().v4(),
      uid: user.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(journalRepositoryProvider).saveJournalEntry(entry);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _save,
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.amber.withValues(alpha: 0.15),
            child: const Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  '🔒 PRIVATE. Your parent cannot read this.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title (optional)',
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
