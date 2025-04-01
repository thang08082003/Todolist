import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/models/todo_group_model.dart';
import 'package:uuid/uuid.dart';

class TodoGroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'todogroup';

  Future<void> addTaskToGroup(TodoGroupModel todoTask) async {
    final String taskId = const Uuid().v4();
    await _firestore
        .collection(collectionName)
        .doc(taskId)
        .set(todoTask.toMap());
  }

  Stream<List<TodoGroupModel>> getTasksStreamByGroupId(String groupId) {
    if (groupId.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection(collectionName)
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TodoGroupModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      return;
    }
    await _firestore.collection(collectionName).doc(taskId).delete();
  }

  Future<void> updateTask(TodoGroupModel todoTask) async {
    await _firestore
        .collection(collectionName)
        .doc(todoTask.id)
        .update(todoTask.toMap());
  }
}
