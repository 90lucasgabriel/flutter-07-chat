import 'package:flutter/material.dart';
import 'package:chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Flutter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Input(),
        ],
      ),
    );
  }
}
