import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todolist/models/action_buttons_model.dart';
import 'package:todolist/services/groups_service.dart';
import 'package:todolist/views/widgets/action_buttons_widget.dart';

class CreateGroupWidget extends StatelessWidget {
  const CreateGroupWidget({required this.groupsService, super.key});

  final GroupsService groupsService;

  @override
  Widget build(BuildContext context) {
    String groupName = '';
    String groupDescription = '';
    final String groupCode = _generateGroupCode();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create New Group',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildGroupForm(
            groupName: groupName,
            groupDescription: groupDescription,
            onGroupNameChanged: (value) => groupName = value,
            onGroupDescriptionChanged: (value) => groupDescription = value,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ActionButtonsWidget(
                  model: ActionButtonModel(
                    backgroundColor: Colors.white,
                    text: "Cancel",
                    foregroundColor: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                child: ActionButtonsWidget(
                  model: ActionButtonModel(
                    backgroundColor: Colors.black,
                    text: "Create",
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      if (groupName.isNotEmpty) {
                        await groupsService.addGroupToFirestore(
                          groupName,
                          groupDescription,
                          groupCode,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupForm({
    required String groupName,
    required String groupDescription,
    required ValueChanged<String> onGroupNameChanged,
    required ValueChanged<String> onGroupDescriptionChanged,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: onGroupNameChanged,
            decoration: const InputDecoration(labelText: 'Group Name'),
          ),
          TextField(
            onChanged: onGroupDescriptionChanged,
            decoration: const InputDecoration(labelText: 'Group Description'),
          ),
        ],
      );

  String _generateGroupCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
