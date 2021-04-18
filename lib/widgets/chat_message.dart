import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  /// Props
  /// Message info
  final Map<String, dynamic> data;

  /// Check if message is mine
  final bool isOwner;

  /// Constructor
  ChatMessage(this.data, this.isOwner);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          if (!isOwner)
            Container(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imageUrl'] != null
                    ? Image.network(
                        data['imageUrl'],
                        width: 250,
                      )
                    : Text(
                        data['value'],
                        textAlign: isOwner ? TextAlign.end : TextAlign.start,
                        style: TextStyle(fontSize: 14),
                      ),
                Text(
                  data['senderName'],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          if (isOwner)
            Container(
              padding: EdgeInsets.only(left: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            ),
        ],
      ),
    );
  }
}
