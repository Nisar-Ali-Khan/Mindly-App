import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_model.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(FirebaseFirestore.instance);
});

class MoodRepository {
  final FirebaseFirestore _firestore;
  final List<MoodEntry> _localMoodLogs = [];

  MoodRepository(this._firestore);

  Future<void> saveMoodEntry(MoodEntry entry) async {
    _localMoodLogs.removeWhere((e) => e.id == entry.id);
    _localMoodLogs.insert(0, entry); // Save to local cache for instant UI response
    try {
      await _firestore.collection('moodLogs').doc(entry.id).set(entry.toMap());
    } catch (e) {
      debugPrint("Saved mood log locally ($e)");
    }
  }

  Stream<List<MoodEntry>> getMoodEntries(String uid) {
    if (uid.startsWith('guest_')) {
      return Stream.value(List.unmodifiable(_localMoodLogs));
    }

    // Query without orderBy to avoid requiring Firebase Composite Indexes!
    return _firestore
        .collection('moodLogs')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final remote = snapshot.docs.map((doc) => MoodEntry.fromMap(doc.data())).toList();
      // Sort in Dart memory so no Firebase Composite Index is needed
      remote.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      for (final entry in remote) {
        if (!_localMoodLogs.any((e) => e.id == entry.id)) {
          _localMoodLogs.add(entry);
        }
      }
      _localMoodLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return List<MoodEntry>.unmodifiable(_localMoodLogs);
    }).handleError((e) {
      debugPrint("Firestore mood stream offline/fallback: $e");
      return List<MoodEntry>.unmodifiable(_localMoodLogs);
    });
  }
}
