import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.groupCode,
    required this.currentUserId,
    super.key,
  });

  final String groupCode;
  final String currentUserId;

  @override
  ChatScreenState createState() => ChatScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('currentUserId', currentUserId))
      ..add(StringProperty('groupCode', groupCode));
  }
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(currentUser.uid).get();

        if (userDoc.exists) {
          final String userName = userDoc['name'] ?? 'Unknown';

          await _firestore
              .collection('groups')
              .doc(widget.groupCode)
              .collection('chats')
              .add({
            'message': _messageController.text.trim(),
            'senderId': currentUser.uid,
            'senderName': userName,
            'sentAt': FieldValue.serverTimestamp(),
          });
          _messageController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(widget.groupCode)
                    .collection('chats')
                    .orderBy('sentAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                          messages[index].data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text('Sent by: ${messageData['senderName']}'),
                        subtitle: Text(messageData['message']),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration:
                          const InputDecoration(hintText: 'Enter message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
