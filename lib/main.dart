import 'package:flutter/material.dart';

// Screens
import 'package:chat_free/screens/chat_screen.dart';
import 'package:chat_free/screens/login_screen.dart';
import 'package:chat_free/screens/registration_screen.dart';
import 'package:chat_free/screens/welcome_screen.dart';
import 'package:chat_free/screens/convo_screen.dart';

void main() => runApp(ChatFree());

class ChatFree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ConvoScreen.id: (context) => ConvoScreen(),
      },
    );
  }
}