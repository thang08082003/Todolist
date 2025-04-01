import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/services/user_services.dart';

final Provider<UserServices> userServiceProvider = Provider<UserServices>(
  (Ref ref) => UserServices(),
);

final StreamProvider<UserModel?> fetchUserStreamProvider =
    StreamProvider<UserModel?>(
  (Ref ref) {
    final UserServices userService = ref.watch(userServiceProvider);
    return userService.fetchUserData();
  },
);
