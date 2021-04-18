import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignin = GoogleSignIn();

  User _user;
  bool _isLoading = false;

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
      print(error);
      return null;
    }
  }

  void _sendMessage({String value, File file}) async {
    final User user = await _getUser();

    if (user == null) {
      Widget snackbar = SnackBar(
        content: Text('Login error. Try again.'),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      return;
    }

    Map<String, dynamic> data = {
      'senderUid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'createdAt': Timestamp.now(),
    };

    if (file != null) {
      setState(() {
        _isLoading = true;
      });

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);

      TaskSnapshot taskSnapshot = await task.whenComplete(() {});
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imageUrl'] = url;

      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _user != null ? 'Hello, ${_user.displayName}' : 'Chat Flutter'),
        actions: [
          if (_user != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();

                Widget snackbar = SnackBar(
                  content: Text('You logged out.'),
                );

                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt')
                  .snapshots(),
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
                        return ChatMessage(
                            documentList[index].data(),
                            documentList[index].data()['senderUid'] ==
                                _user?.uid);
                      },
                    );
                }
              },
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Input(_sendMessage),
        ],
      ),
    );
  }
}
