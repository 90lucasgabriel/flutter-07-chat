import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat/ui/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Home());
}

class Home extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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

        return CircularProgressIndicator();
      },
    );
  }
}
