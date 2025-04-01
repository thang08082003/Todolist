import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todolist/models/user_model.dart';

class UserServices {
  final CollectionReference<Object?> userCollection =
      FirebaseFirestore.instance.collection("user");

  Future<void> updateUser(String uid, String? name) =>
      userCollection.doc(uid).update(<String, Object?>{
        "name": name,
      });

  Future<void> updateUserPhotoURL(String uid, String photoURL) =>
      userCollection.doc(uid).set(
        {
          "photoURL": photoURL,
        },
        SetOptions(merge: true),
      );

  Stream<UserModel?> fetchUserData() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return userCollection.doc(user.uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        return null;
      }
    });
  }

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final QuerySnapshot<Object?> snapshot = await userCollection.get();

      return snapshot.docs
          .map(
            (doc) => UserModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      rethrow;
    }
  }
}
