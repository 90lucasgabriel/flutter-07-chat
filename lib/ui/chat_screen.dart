import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage({String value, File file}) async {
    Map<String, dynamic> data = {};

    if (file != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);

      TaskSnapshot taskSnapshot = await task.whenComplete(() {});
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imageUrl'] = url;
    }

    if (value != null) {
      data['value'] = value;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
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
