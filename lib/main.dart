import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    return firestore.collection('users').add({
      'name': 'Lucas Gabriel Teixeira',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextButton(
        onPressed: addUser,
        child: Text(
          "Add User",
        ),
      ),
    );
  }
}
