import 'package:flutter/material.dart';
import 'package:todolist/models/user_model.dart';
import 'package:todolist/services/user_services.dart';

void viewMembersScreen(BuildContext context, List<String> members) {
  final UserServices userServices = UserServices();

  userServices.fetchAllUsers().then((users) {
    if (context.mounted) {
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
            children: [
              const Text(
                'Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final String memberId = members[index];
                    final UserModel memberUser = users.firstWhere(
                      (user) => user.uid == memberId,
                      orElse: () => UserModel(
                        uid: memberId,
                        name: 'Unknown',
                        email: '',
                        photoURL: '',
                      ),
                    );
                    return ListTile(
                      title: Text(memberUser.name),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    }
  }).catchError((error) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to fetch user data: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
  });
}
