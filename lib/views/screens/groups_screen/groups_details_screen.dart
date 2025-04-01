import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/groups_model.dart';
import 'package:todolist/models/todo_group_model.dart';
import 'package:todolist/view_model/controllers/todo_group_controller.dart';
import 'package:todolist/views/screens/chat_screen/chat_screen.dart';
import 'package:todolist/views/screens/groups_screen/add_group_task_screen.dart';
import 'package:todolist/views/screens/groups_screen/agora_meeting_screen.dart';
import 'package:todolist/views/screens/groups_screen/view_members_screen.dart';

class GroupsDetailsScreen extends StatefulWidget {
  const GroupsDetailsScreen({
    required this.group,
    required this.currentUserId,
    required this.currentUserName,
    super.key,
  });

  final GroupsModel group;
  final String currentUserId;
  final String currentUserName;

  @override
  GroupsDetailsScreenState createState() => GroupsDetailsScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('currentUserId', currentUserId))
      ..add(DiagnosticsProperty<GroupsModel>('group', group))
      ..add(StringProperty('currentUserName', currentUserName));
  }
}

class GroupsDetailsScreenState extends State<GroupsDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.group.name),
              Text(
                widget.group.groupCode,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.people, color: Colors.black),
              onPressed: () => viewMembersScreen(context, widget.group.members),
            ),
            IconButton(
              icon: const Icon(Icons.videocam, color: Colors.black),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AgoraMeetingScreen(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () =>
                  addGroupTaskScreen(context, widget.group.groupCode),
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Tasks"),
              Tab(text: "Chats"),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _buildTasksTab(),
            ChatScreen(
              groupCode: widget.group.groupCode,
              currentUserId: widget.currentUserId,
            ),
          ],
        ),
      );

  Widget _buildTasksTab() => StreamBuilder<List<TodoGroupModel>>(
        stream: TodoGroupController()
            .getTasksStreamByGroupId(widget.group.groupCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text(task.scheduledDate.toString()),
                );
              },
            ),
          );
        },
      );
}
