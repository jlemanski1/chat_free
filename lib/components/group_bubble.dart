import 'package:flutter/material.dart';

class GroupBubble extends StatelessWidget {
  final String name;
  final List<dynamic> users;

  GroupBubble({@required this.name, @required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
            ),
            color: Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  users.toString(),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}