import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/models/action_buttons_model.dart';
import 'package:todolist/models/date_time_model.dart';
import 'package:todolist/models/radio_list_model.dart';
import 'package:todolist/models/text_field_model.dart';
import 'package:todolist/models/todo_category.dart';
import 'package:todolist/view_model/controllers/category_controller.dart';
import 'package:todolist/view_model/controllers/date_time_controller.dart';
import 'package:todolist/view_model/controllers/todo_controller.dart';
import 'package:todolist/views/widgets/action_buttons_widget.dart';
import 'package:todolist/views/widgets/date_time_widget.dart';
import 'package:todolist/views/widgets/radio_list_widget.dart';
import 'package:todolist/views/widgets/text_field_widget.dart';

class AddNewTaskScreen extends HookConsumerWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();

    final CategoryController categoryController = CategoryController(ref);
    final DateTimeController dateTimeController = DateTimeController(ref);
    final TodoController taskController = TodoController(
      ref,
      titleController,
      descriptionController,
    );

    return Container(

      height: MediaQuery.of(context).size.height * 0.60,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text(
                "New Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              thickness: 1.2,
              color: Colors.grey,
            ),
            const Text(
              "Title Task",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              model: TextFieldModel(
                hintText: "Add Task Name",
                maxLine: 1,
                txtController: titleController,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              model: TextFieldModel(
                hintText: "Add Description",
                maxLine: 5,
                txtController: descriptionController,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: <Widget>[
                SizedBox(
                  child: RadioListWidget(
                    model: RadioListModel(
                      cateColor: TodoCategory.learn.color,
                      titleRadio: TodoCategory.learn.displayTitle,
                      valueInput: TodoCategory.learn.index,
                    ),
                    onChangeValue: () =>
                        categoryController.selectCategory(TodoCategory.learn),
                    isSelected: categoryController.selectedCategory ==
                        TodoCategory.learn,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: RadioListWidget(
                    model: RadioListModel(
                      cateColor: TodoCategory.work.color,
                      titleRadio: TodoCategory.work.displayTitle,
                      valueInput: TodoCategory.work.index,
                    ),
                    onChangeValue: () =>
                        categoryController.selectCategory(TodoCategory.work),
                    isSelected: categoryController.selectedCategory ==
                        TodoCategory.work,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: RadioListWidget(
                    model: RadioListModel(
                      cateColor: TodoCategory.general.color,
                      titleRadio: TodoCategory.general.displayTitle,
                      valueInput: TodoCategory.general.index,
                    ),
                    onChangeValue: () =>
                        categoryController.selectCategory(TodoCategory.general),
                    isSelected: categoryController.selectedCategory ==
                        TodoCategory.general,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DateTimeWidget(
                  model: DateTimeModel(
                    iconSection: CupertinoIcons.calendar,
                    titleText: "Date",
                    valueText: dateTimeController.date,
                    onTap: () async => dateTimeController.pickDate(context),
                  ),
                ),
                const SizedBox(height: 10),
                DateTimeWidget(
                  model: DateTimeModel(
                    iconSection: CupertinoIcons.clock,
                    titleText: "Time",
                    valueText: dateTimeController.time,
                    onTap: () async => dateTimeController.pickTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
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
                      onPressed: () async => taskController.createTask(context),
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
}
