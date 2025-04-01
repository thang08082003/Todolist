import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:todolist/models/todo_category.dart";
import "package:todolist/providers/radio_provider.dart";

class CategoryController {
  CategoryController(this.ref);

  final WidgetRef ref;

  TodoCategory get selectedCategory => ref.watch(radioProvider);

  set selectedCategory(TodoCategory category) {
    ref.read(radioProvider.notifier).state = category;
  }

  void selectCategory(TodoCategory category) {
    selectedCategory = category;
  }
}
