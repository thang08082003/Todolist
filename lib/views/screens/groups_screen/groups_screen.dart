import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/groups_model.dart';
import 'package:todolist/services/groups_service.dart';
import 'package:todolist/utils/theme/app_text_style.dart';
import 'package:todolist/views/screens/groups_screen/create_group_widget.dart';
import 'package:todolist/views/screens/groups_screen/group_search_widget.dart';
import 'package:todolist/views/screens/groups_screen/groups_details_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  GroupsScreenState createState() => GroupsScreenState();
}

class GroupsScreenState extends State<GroupsScreen> {
  final GroupsService _groupsService = GroupsService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'My Groups',
            style: AppTextStyle.header,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildSearchGroupField(),
            _buildGroupSection(_groupsService.fetchJoinedGroups()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: _createGroup,
          tooltip: 'Create Group',
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );

  Widget _buildSearchGroupField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter group code...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _searchGroupByCode(value);
            }
          },
        ),
      );

  Widget _buildGroupSection(
    Stream<QuerySnapshot<Map<String, dynamic>>> stream,
  ) =>
      Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No groups found.'));
            }

            final List<GroupsModel> groups =
                snapshot.data!.docs.map(GroupsModel.fromSnapshot).toList();

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  title: Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(group.description),
                  onTap: () => _navigateToGroupDetails(group),
                );
              },
            );
          },
        ),
      );

  void _createGroup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          CreateGroupWidget(groupsService: _groupsService),
    );
  }

  Future<void> _searchGroupByCode(String groupCode) => searchGroupByCode(
        context: context,
        groupsService: _groupsService,
        groupCode: groupCode,
      );

  void _navigateToGroupDetails(GroupsModel group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsDetailsScreen(
          group: group,
          currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
          currentUserName: '',
        ),
      ),
    );
  }
}
