import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/providers/user_service_provider.dart';

class ProfileController {
  Stream<UserModel?> fetchUserData(WidgetRef ref) =>
      ref.watch(userServiceProvider).fetchUserData();
}
