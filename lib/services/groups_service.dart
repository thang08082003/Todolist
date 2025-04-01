import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todolist/models/groups_model.dart';

class GroupsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchJoinedGroups() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    final userId = currentUser.uid;
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots();
  }

  Future<void> addGroupToFirestore(
    String groupName,
    String groupDescription,
    String groupCode,
  ) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint('User is not logged in.');
      return;
    }

    final userId = currentUser.uid;
    await _firestore.collection('groups').add({
      'name': groupName,
      'description': groupDescription,
      'createdBy': userId,
      'members': [userId],
      'groupCode': groupCode,
      'createdAt': Timestamp.now(),
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchGroupByCode(
    String groupCode,
  ) async =>
      _firestore
          .collection('groups')
          .where('groupCode', isEqualTo: groupCode)
          .get();

  Future<void> addUserToGroup(GroupsModel group, String userId) async {
    final querySnapshot = await _firestore
        .collection('groups')
        .where('groupCode', isEqualTo: group.groupCode)
        .get();

    if (querySnapshot.docs.isEmpty) {
      debugPrint('Group not found with groupCode: ${group.groupCode}');
      return;
    }

    final documentId = querySnapshot.docs.first.id;
    await _firestore.collection('groups').doc(documentId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }
}
