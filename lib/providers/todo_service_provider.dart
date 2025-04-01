import "package:riverpod/riverpod.dart";
import "package:todolist/models/todo_model.dart";
import "package:todolist/services/todo_services.dart";

final Provider<TodoServices> todoRepositoryProvider = Provider<TodoServices>(
  (Ref ref) => TodoServices(),
);

final StreamProvider<List<TodoModel>> fetchStreamProvider =
    StreamProvider<List<TodoModel>>(
  (Ref ref) {
    final TodoServices repository = ref.watch(todoRepositoryProvider);
    return repository.fetchTodoList();
  },
);
