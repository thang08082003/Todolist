import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsModel {
  GroupsModel({
    required this.name,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.groupCode,
    required this.createdAt,
  });

  factory GroupsModel.fromMap(Map<String, dynamic> map) => GroupsModel(
        name: map['name'] as String,
        description: map['description'] as String,
        createdBy: map['createdBy'] as String,
        members: List<String>.from(map['members'] as List<dynamic>),
        groupCode: map['groupCode'] as String,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );

  factory GroupsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      GroupsModel(
        name: doc.data()?['name'] as String,
        description: doc.data()?['description'] as String,
        createdBy: doc.data()?['createdBy'] as String,
        members: List<String>.from(doc.data()?['members'] as List<dynamic>),
        groupCode: doc.data()?['groupCode'] as String,
        createdAt: (doc.data()?['createdAt'] as Timestamp).toDate(),
      );

  factory GroupsModel.fromJson(String source) =>
      GroupsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String name;
  final String description;
  final String createdBy;
  final List<String> members;
  final String groupCode;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'description': description,
        'createdBy': createdBy,
        'members': members,
        'groupCode': groupCode,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  String toJson() => json.encode(toMap());
}
