import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/models/todo_model.dart';

class TodoServices {
  final CollectionReference<Object?> todoCollection =
      FirebaseFirestore.instance.collection("todolist");

  Future<void> addNewTask(TodoModel model) async {
    await todoCollection.doc(model.docID).set(model.toMap());
  }

  Future<void> updateTask(String? docID, bool? valueUpdate) =>
      todoCollection.doc(docID).update(<String, Object?>{
        "isDone": valueUpdate,
      });

  Future<void> deleteTask(String? docID) => todoCollection.doc(docID).delete();

  Stream<List<TodoModel>> fetchTodoList() {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return todoCollection
        .where("uid", isEqualTo: currentUserUid)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) => querySnapshot.docs
              .map(
                (QueryDocumentSnapshot<Object?> doc) => TodoModel.fromSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList(),
        );
  }
}
