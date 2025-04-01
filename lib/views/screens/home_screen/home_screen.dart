import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/models/todo_model.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/providers/todo_service_provider.dart';
import 'package:todolist/view_model/controllers/profile_controller.dart';
import 'package:todolist/views/screens/home_screen/add_new_task_screen.dart';
import 'package:todolist/views/widgets/commons_widget/todo_card_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TodoModel>> todoData = ref.watch(fetchStreamProvider);
    final ProfileController profileController = ProfileController();

    final Stream<UserModel?> userDataStream =
        profileController.fetchUserData(ref);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: StreamBuilder<UserModel?>(
          stream: userDataStream,
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No user data');
            }

            final UserModel user = snapshot.data!;

            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.photoURL),
              ),
              title: Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
              subtitle: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Today's Task",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "What you wanna do?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async => showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    context: context,
                    constraints:  BoxConstraints(

                      maxWidth: MediaQuery.of(context).size.width - 5,
                      minWidth: 300,
                    ),
                    builder: (BuildContext context) => const AddNewTaskScreen(),
                  ),
                  child: const Text(
                    "+ New Task",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: todoData.when(
                data: (List<TodoModel> todos) => ListView.separated(
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final TodoModel todoItem = todos[index];
                    return Dismissible(
                      key: Key(todoItem.docID),
                      onDismissed: (DismissDirection direction) async {
                        await ref
                            .read(todoRepositoryProvider)
                            .deleteTask(todoItem.docID);
                      },
                      background: const ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: Icon(CupertinoIcons.trash),
                        ),
                      ),
                      child: TodoCardWidget(todoItem: todoItem),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stack) =>
                    Center(child: Text("Error: $error")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
