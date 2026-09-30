import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return ParentRepository(FirebaseFirestore.instance);
});

class ParentRepository {
  final FirebaseFirestore _firestore;

  ParentRepository(this._firestore);

  Future<String> generateConnectionCode(String parentUid) async {
    // In a real app, generate a unique short code and store it in a 'connectionCodes' collection
    final code = parentUid.substring(0, 6).toUpperCase();
    await _firestore.collection('connectionCodes').doc(code).set({
      'parentUid': parentUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  Future<void> connectTeen(String code, String teenUid) async {
    final doc = await _firestore.collection('connectionCodes').doc(code).get();
    if (!doc.exists) throw Exception('Invalid code');
    
    final parentUid = doc.data()!['parentUid'];
    
    // Create connection
    await _firestore.collection('parentConnections').add({
      'parentUid': parentUid,
      'teenUid': teenUid,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update user profiles
    await _firestore.collection('users').doc(teenUid).update({'connectedParentUid': parentUid});
    await _firestore.collection('users').doc(parentUid).update({'connectedTeenUid': teenUid});
  }

  Stream<DocumentSnapshot> getTeenSummary(String teenUid) {
    return _firestore.collection('parentSummaries').doc(teenUid).snapshots();
  }
}
