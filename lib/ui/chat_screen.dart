import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage(String value) {
    FirebaseFirestore.instance.collection('messages').add({'value': value});
  }

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
          Input(_sendMessage),
        ],
      ),
    );
  }
}
