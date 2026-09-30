import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  final String id;
  final String uid;
  final String mood; // Great, Good, Okay, Low, Rough
  final int energy; // 0-10
  final int stress; // 0-10
  final List<String> reasons;
  final String? note;
  final DateTime createdAt;

  const MoodEntry({
    required this.id,
    required this.uid,
    required this.mood,
    required this.energy,
    required this.stress,
    this.reasons = const [],
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'mood': mood,
      'energy': energy,
      'stress': stress,
      'reasons': reasons,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      mood: map['mood'] ?? 'Okay',
      energy: map['energy'] ?? 5,
      stress: map['stress'] ?? 5,
      reasons: List<String>.from(map['reasons'] ?? []),
      note: map['note'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  List<Object?> get props => [id, uid, mood, energy, stress, reasons, note, createdAt];
}
