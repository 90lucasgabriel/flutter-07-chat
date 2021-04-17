import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _isSendEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _isSendEnabled = value.isNotEmpty;
                });
              },
              // onSubmitted: () {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isSendEnabled ? () {} : null,
          ),
        ],
      ),
    );
  }
}
