import "dart:convert";
import "package:cloud_firestore/cloud_firestore.dart";

class TodoModel {
  TodoModel({
    required this.uid,
    required this.titleTask,
    required this.description,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
    required this.docID,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) => TodoModel(
        docID: map["docID"] as String,
        uid: map["uid"] as String,
        titleTask: map["titleTask"] as String,
        description: map["description"] as String,
        category: map["category"] as String,
        dateTask: map["dateTask"] as String,
        timeTask: map["timeTask"] as String,
        isDone: map["isDone"] as bool,
      );

  factory TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      TodoModel(
        docID: doc["docID"],
        uid: doc["uid"],
        titleTask: doc["titleTask"],
        description: doc["description"],
        category: doc["category"],
        dateTask: doc["dateTask"],
        timeTask: doc["timeTask"],
        isDone: doc["isDone"],
      );

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String docID;
  final String uid;
  final String titleTask;
  final String description;
  final String category;
  final String dateTask;
  final String timeTask;
  final bool isDone;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "uid": uid,
        "titleTask": titleTask,
        "description": description,
        "category": category,
        "dateTask": dateTask,
        "timeTask": timeTask,
        "isDone": isDone,
        "docID": docID,
      };

  String toJson() => json.encode(toMap());
}
