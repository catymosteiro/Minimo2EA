import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'user.dart';

class ChatMessage {
  User user;
  String message;
  DateTime date;

  ChatMessage({required this.user, required this.message, required this.date});

  factory ChatMessage.fromJson(dynamic json) {
    return ChatMessage(
        user: json['user'].toString().contains('{')
            ? User.fromJson(json['user'])
            : json['user'],
        message: json['message'] as String,
        date: DateTime.now()); //DateTime.parse(['date']as String));
  }

  static List<ChatMessage> chatMessageFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ChatMessage.fromJson(data);
    }).toList();
  }

  static Map<String, dynamic> toJson(ChatMessage values) {
    return {
      'user': User.toJson(values.user),
      'message': values.message,
      'date': values.date.toString()
    };
  }
}
