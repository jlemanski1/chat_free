import 'package:chat_free/components/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MessageStream extends StatelessWidget {
  final snapshots;
  final loggedInUser;

  MessageStream({@required this.snapshots, @required this.loggedInUser});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (context, snapshot) {
        // Loading Spinnger if snapshot has no data
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        // snapshot contains data from Cloud FireStore
        final msgs = snapshot.data.documents;

        List<MessageBubble> msgBubbles = [];
        for (var msg in msgs) {
          final msgText = msg.data['text'];
          final msgSender = msg.data['sender'];
          final currentUser = loggedInUser.email;

          if (currentUser == msgSender) {

          }

          final msgBubble = MessageBubble(
            sender: msgSender,
            text: msgText,
            myMsg: currentUser == msgSender,
          );
          msgBubbles.add(msgBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            reverse: true,
            children: msgBubbles,
          ),
        );
      },
    );
  }
}