import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'package:chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignin = GoogleSignIn();
  User _user;

  Future<User> _getUser() async {
    try {
      if (_user != null) return _user;

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = userCredential.user;

      return user;
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String value, File file}) async {
    final User user = await _getUser();

    if (user == null) {
      Widget snackbar = SnackBar(
        content: Text('Não foi possível realizar o login. Tente novamente.'),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    Map<String, dynamic> data = {
      'senderUid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
    };

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
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
    });
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
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documentList =
                        snapshot.data.docs.reversed.toList();

                    return ListView.builder(
                      itemCount: documentList.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(documentList[index].data()['value']),
                        );
                      },
                    );
                }
              },
            ),
          ),
          Input(_sendMessage),
        ],
      ),
    );
  }
}
