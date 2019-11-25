import 'package:flutter/material.dart';
import 'package:chat_free/components/group_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupStream extends StatelessWidget {
  final snapshots;
  final loggedInUser;

  GroupStream({@required this.snapshots, @required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (context, snapshot) {
        // Load if snapshot has no data
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // snapshot contains data from cloud firestore
        final groups = snapshot.data.documents;

        List<GroupBubble> groupBubbles = [];
        for (var group in groups) {
          final groupName = group.data['name'];
          final groupUsers = group.data['users'];

          final groupBubble = GroupBubble(
            name: groupName,
            users: groupUsers,
          );
          groupBubbles.add(groupBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            reverse: true,
            children: groupBubbles,
          ),
        );
      }
      
    );
  }
}