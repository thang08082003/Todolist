import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/providers/user_service_provider.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:todolist/utils/theme/app_text_style.dart';
import 'package:todolist/view_model/controllers/edit_profile_controller.dart';
import 'package:todolist/view_model/controllers/signout_controller.dart';
import 'package:todolist/views/widgets/commons_widget/custombutton_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutController = SignOutController();
    final editProfileController = EditProfileController();

    final userDataStream = ref.watch(userServiceProvider).fetchUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(AppText.profileTitle, style: AppTextStyle.header),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              StreamBuilder<UserModel?>(
                stream: userDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Name: ${user.name}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Email: ${user.email}",
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          onPressed: () async {
                            await editProfileController.showEditDialog(
                              context,
                              ref,
                              user,
                            );
                          },
                          text: 'Edit Name',
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          onPressed: () async {
                            await editProfileController.updateProfilePicture(
                              context,
                              ref,
                              user,
                            );
                            ref.invalidate(userServiceProvider);
                          },
                          text: 'Edit Avatar',
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  await signOutController.showSignOutDialog(context, ref);
                },
                text: 'Sign Out',
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
