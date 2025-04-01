// models/join_request_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequestModel {
  JoinRequestModel({
    required this.uid,
    required this.groupCode,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory JoinRequestModel.fromMap(Map<String, dynamic> data) =>
      JoinRequestModel(
        uid: data['uid'],
        groupCode: data['groupCode'],
        name: data['name'],
        email: data['email'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
  final String uid; // UID của người gửi yêu cầu
  final String groupCode; // Mã nhóm
  final String name; // Tên người gửi yêu cầu
  final String email; // Email của người gửi yêu cầu
  final DateTime createdAt;

  // Phương thức chuyển đổi từ JoinRequestModel sang Map
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'groupCode': groupCode,
        'name': name,
        'email': email,
        'createdAt': createdAt,
      };
}
