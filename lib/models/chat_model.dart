import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.groupCode,
    required this.sentAt,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ChatModel(
        message: doc['message'] as String,
        senderId: doc['senderId'] as String,
        senderName: doc['senderName'] as String,
        groupCode: doc['groupCode'] as String,
        sentAt: (doc['sentAt'] as Timestamp).toDate(),
      );

  factory ChatModel.fromMap(Map<String, dynamic> map) => ChatModel(
        message: map['message'] as String,
        senderId: map['senderId'] as String,
        senderName: map['senderName'] as String,
        groupCode: map['groupCode'] as String,
        sentAt: (map['sentAt'] as Timestamp).toDate(),
      );

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String message;
  final String senderId;
  final String senderName;
  final String groupCode;
  final DateTime sentAt;

  Map<String, dynamic> toMap() => {
        'message': message,
        'senderId': senderId,
        'senderName': senderName,
        'groupCode': groupCode,
        'sentAt': Timestamp.fromDate(sentAt),
      };

  String toJson() => json.encode(toMap());
}
