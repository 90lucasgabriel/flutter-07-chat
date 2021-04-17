import 'package:flutter/material.dart';
import 'package:chat/ui/chat_screen.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      home: ChatScreen(),
    );
  }
}
