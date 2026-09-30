import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String uid;
  final String title;
  final String content;
  final List<String> tags;
  final String mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    this.tags = const [],
    this.mood = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'tags': tags,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      mood: map['mood'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id, uid, title, content, tags, mood, createdAt, updatedAt];
}
