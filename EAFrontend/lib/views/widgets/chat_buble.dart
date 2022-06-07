import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  ChatBuble(this.mymessage, this.text);
  final bool mymessage;
  final String text;
  @override
  Widget build(BuildContext context) {
    //ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);

    if (mymessage) {
      // right side (my message)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ListTile(title: Text(text))],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [ListTile(title: Text(text))],
          ),
        ],
      );
    }
  }
}
