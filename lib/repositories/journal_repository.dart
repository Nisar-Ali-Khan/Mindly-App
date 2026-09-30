import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_model.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(FirebaseFirestore.instance);
});

class JournalRepository {
  final FirebaseFirestore _firestore;
  final List<JournalEntry> _localJournals = [];

  JournalRepository(this._firestore);

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final existingIndex = _localJournals.indexWhere((e) => e.id == entry.id);
    if (existingIndex >= 0) {
      _localJournals[existingIndex] = entry;
    } else {
      _localJournals.insert(0, entry);
    }

    try {
      await _firestore.collection('journals').doc(entry.id).set(entry.toMap());
    } catch (e) {
      debugPrint("Saved journal entry locally ($e)");
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    _localJournals.removeWhere((e) => e.id == id);
    try {
      await _firestore.collection('journals').doc(id).delete();
    } catch (e) {
      debugPrint("Deleted journal locally ($e)");
    }
  }

  Stream<List<JournalEntry>> getJournalEntries(String uid) {
    if (uid.startsWith('guest_')) {
      return Stream.value(List.unmodifiable(_localJournals));
    }

    // Query without orderBy to avoid requiring Firebase Composite Indexes!
    return _firestore
        .collection('journals')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final remote = snapshot.docs.map((doc) => JournalEntry.fromMap(doc.data())).toList();
      // Sort in Dart memory so no Firebase Composite Index is needed
      remote.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      for (final entry in remote) {
        if (!_localJournals.any((e) => e.id == entry.id)) {
          _localJournals.add(entry);
        }
      }
      _localJournals.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return List<JournalEntry>.unmodifiable(_localJournals);
    }).handleError((e) {
      debugPrint("Firestore journal stream offline/fallback: $e");
      return List<JournalEntry>.unmodifiable(_localJournals);
    });
  }
}
