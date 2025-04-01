import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        photoURL: map['photoURL'] as String,
      );

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserModel(
        uid: doc.id,
        name: doc.data()?['name'] ?? 'Unknown',
        email: doc.data()?['email'] ?? '',
        photoURL: doc.data()?['photoURL'] ?? '',
      );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String uid;
  final String name;
  final String email;
  final String photoURL;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uid': uid,
        'name': name,
        'email': email,
        'photoURL': photoURL,
      };

  String toJson() => json.encode(toMap());
}
