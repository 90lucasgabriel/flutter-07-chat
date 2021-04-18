import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Input extends StatefulWidget {
  /// Send message to Firebase
  final Function({String value, File file}) sendMessage;

  /// Constructor
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
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              final PickedFile response =
                  await _picker.getImage(source: ImageSource.camera);
              final File file = File(response.path);

              if (response == null) return;
              widget.sendMessage(file: file);
            },
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
                widget.sendMessage(value: value);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isSendEnabled
                ? () {
                    widget.sendMessage(value: _messageController.text);
                    _reset();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
