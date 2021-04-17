import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat/ui/chat_screen.dart';

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
  }

  @override
  void initState() {
    super.initState();
    firebaseInit();
  }

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
