import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/providers/user_service_provider.dart';
import 'package:todolist/services/image_services.dart';

class EditProfileController {
  final ImageService _imageService = ImageService();

  Future<void> showEditDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final TextEditingController nameController =
        TextEditingController(text: user.name);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Name',
          style: TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await ref.read(userServiceProvider).updateUser(
                    FirebaseAuth.instance.currentUser!.uid,
                    nameController.text,
                  );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateProfilePicture(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final XFile? image = await _imageService.pickImage();
    if (image != null) {
      final String? downloadUrl =
          await _imageService.uploadImageToFirebase(image);
      if (downloadUrl != null) {
        await ref.read(userServiceProvider).updateUserPhotoURL(
              user.uid,
              downloadUrl,
            );
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }
}
