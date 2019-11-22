import 'package:chat_free/components/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:chat_free/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;


class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen'; // ID of this particular screen

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController msgTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      // User is signed in
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Chat Free'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      decoration: kMessageTextFieldDecoration,
                      onChanged: (value) {
                        messageText = value;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': Timestamp.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
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