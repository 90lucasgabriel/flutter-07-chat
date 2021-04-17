import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  Future<void> addUser() async {
    return FirebaseFirestore.instance
        .collection('COLLECTION_NAME')
        .doc('DOC_ID')
        .collection('SUBCOLLECTION_NAME')
        .doc()
        .set({'file': 'filename'});
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

    // return FutureBuilder(
    //   future: _firebaseInit(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return MaterialApp(
    //         home: TextButton(
    //           onPressed: addUser,
    //           child: Text(
    //             "Add User",
    //           ),
    //         ),
    //       );
    //     }

    //     return MaterialApp(home: CircularProgressIndicator());
    //   },
    // );
  }
}
