import 'package:flutter/material.dart';
import 'package:todolist/models/action_buttons_model.dart';
import 'package:todolist/utils/constants.dart';
import 'package:todolist/utils/utils.dart';
import 'package:todolist/view_model/controllers/todo_group_controller.dart';
import 'package:todolist/views/widgets/action_buttons_widget.dart';

void addGroupTaskScreen(BuildContext context, String groupCode) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  DateTime? scheduledDate;
  TimeOfDay? selectedTime;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Container(
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
            'New Task',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Task Description'),
          ),
          TextField(
            controller: dateController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Selected Date'),
            onTap: () async {
              final pickedDate = await pickDate(context);
              if (pickedDate != null) {
                scheduledDate = pickedDate;
                setFormattedDate(
                  date: scheduledDate!,
                  controller: dateController,
                );
              }
            },
          ),
          TextField(
            controller: timeController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Selected Time'),
            onTap: () async {
              final pickedTime = await pickTime(context);
              if (pickedTime != null) {
                selectedTime = pickedTime;
                setFormattedTime(
                  time: selectedTime!,
                  controller: timeController,
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: ActionButtonsWidget(
                  model: ActionButtonModel(
                    backgroundColor: Colors.white,
                    text: 'Cancel',
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
                    text: 'Create',
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      if (titleController.text.isNotEmpty &&
                          scheduledDate != null &&
                          selectedTime != null) {
                        convertStringToDate(
                          time: '${dateController.text} ${timeController.text}',
                          dateFormat: kDateTimeFormat,
                        );

                        final todoGroupController = TodoGroupController();

                        try {
                          await todoGroupController.createTask(
                            titleController.text,
                            descriptionController.text,
                            scheduledDate!,
                            selectedTime!,
                            groupCode,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error creating task'),
                              ),
                            );
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields.'),
                            ),
                          );
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
    ),
  );
}
