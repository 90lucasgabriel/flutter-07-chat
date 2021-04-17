import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void firebaseInit() async {
    await Firebase.initializeApp();
    checkUpdates();
  }

  void addUser() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set({'name': 'Name Lastname'});
  }

  void getData() async {
    QuerySnapshot messages =
        await FirebaseFirestore.instance.collection('messages').get();
    messages.docs.forEach((element) {
      print(element.data());
    });
  }

  void checkUpdates() {
    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: addUser,
            child: Text(
              "Add User",
            ),
          ),
          TextButton(
            onPressed: getData,
            child: Text(
              "Read User documents",
            ),
          ),
        ],
      ),
    );
  }
}
