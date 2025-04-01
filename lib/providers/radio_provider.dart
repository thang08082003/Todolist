import "package:riverpod/riverpod.dart";
import "package:todolist/models/todo_category.dart";

final StateProvider<TodoCategory> radioProvider = StateProvider<TodoCategory>(
  (Ref ref) => TodoCategory.learn,
);
