import 'package:chat_free/components/group_stream.dart';
import 'package:chat_free/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ConvoScreen extends StatefulWidget {
  static const String id = 'registration_screen'; // ID of this particular screen

  @override
  _ConvoScreenState createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController msgTextController = TextEditingController();
  String msgText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      // user is signed in
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
      backgroundColor: Colors.white,
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
        title: Text(
          'Conversations',
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GroupStream(
              snapshots: _fireStore.collection('groups').orderBy('timestamp', descending: true).snapshots(),
              loggedInUser: loggedInUser,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        hintText: 'Start a group, add some friends!',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        msgText = value;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgTextController.clear();
                      _fireStore.collection('groups').add({
                        // TODO: Create new group in firestore database
                        
                      });
                    },
                    child: Text(
                      'Add',
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