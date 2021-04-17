import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  /**
   * Send message to Firebase
   */
  final Function(String) sendMessage;

  /**
   * Constructor
   */
  Input(this.sendMessage);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _isSendEnabled = false;
  final TextEditingController _messageController = TextEditingController();

  void _reset() {
    _messageController.clear();
    setState(() {
      _isSendEnabled = false;
    });
  }

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
              controller: _messageController,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _isSendEnabled = value.isNotEmpty;
                });
              },
              onSubmitted: (value) {
                widget.sendMessage(value);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isSendEnabled
                ? () {
                    widget.sendMessage(_messageController.text);
                    _reset();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
