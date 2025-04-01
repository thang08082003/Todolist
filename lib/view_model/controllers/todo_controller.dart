import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/local_notification/notification_service.dart';
import 'package:todolist/models/todo_category.dart';
import 'package:todolist/models/todo_model.dart';
import 'package:todolist/providers/date_time_provider.dart';
import 'package:todolist/providers/radio_provider.dart';
import 'package:todolist/providers/todo_service_provider.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:uuid/uuid.dart';

class TodoController {
  TodoController(this.ref, this.titleController, this.descriptionController);

  final WidgetRef ref;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Uuid uuid = const Uuid();
  final NotificationService notificationService = NotificationService();

  Future<void> createTask(BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(AppText.missingValueTitle),
          content: const Text(AppText.missingValueContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final String generatedDocID = uuid.v4();
    final TodoCategory selectedCategory = ref.read(radioProvider);
    final String date = ref.read(dateProvider);
    final String time = ref.read(timeProvider);

    final TodoModel newTask = TodoModel(
      uid: currentUser.uid,
      titleTask: titleController.text,
      description: descriptionController.text,
      category: selectedCategory.displayTitle,
      dateTask: date,
      timeTask: time,
      isDone: false,
      docID: generatedDocID,
    );

    await ref.read(todoRepositoryProvider).addNewTask(newTask);

    await Fluttertoast.showToast(
      msg: "Completed!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );

    await notificationService.scheduleTaskReminder(
      newTask.titleTask,
      date,
      time,
    );

    await Fluttertoast.showToast(
      msg: "Reminder set in $time $date!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );

    if (context.mounted) {
      Navigator.pop(context);
      titleController.clear();
      descriptionController.clear();
    }
  }
}
