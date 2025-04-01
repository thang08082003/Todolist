import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/action_buttons_model.dart';
import 'package:todolist/models/groups_model.dart';
import 'package:todolist/services/groups_service.dart';
import 'package:todolist/views/widgets/action_buttons_widget.dart';

Future<void> searchGroupByCode({
  required BuildContext context,
  required GroupsService groupsService,
  required String groupCode,
}) async {
  try {
    final result = await groupsService.searchGroupByCode(groupCode);

    if (result.docs.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group not found')),
        );
      }
      return;
    }

    final groupDoc = result.docs.first;
    final group = GroupsModel.fromSnapshot(groupDoc);

    if (context.mounted) {
      showGroupDetailsDialog(
        context: context,
        group: group,
        groupsService: groupsService,
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error searching group')),
      );
    }
  }
}

void showGroupDetailsDialog({
  required BuildContext context,
  required GroupsModel group,
  required GroupsService groupsService,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(group.name),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(group.description),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: ActionButtonsWidget(
                  model: ActionButtonModel(
                    backgroundColor: Colors.white,
                    text: 'Join',
                    foregroundColor: Colors.black,
                    onPressed: () async {
                      final String? userId =
                          FirebaseAuth.instance.currentUser?.uid;

                      if (userId == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User not logged in')),
                          );
                        }
                        return;
                      }

                      try {
                        await groupsService.addUserToGroup(group, userId);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Joined the group!')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error joining group'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: ActionButtonsWidget(
                  model: ActionButtonModel(
                    backgroundColor: Colors.white,
                    text: 'Close',
                    foregroundColor: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
