import 'user.dart';
import 'chat_message.dart';
import 'dart:developer';

class Chat {
  String id;
  String name;
  List<dynamic> messages;
  List<dynamic> users;

  Chat(
      {required this.id,
      required this.name,
      required this.messages,
      required this.users});

  factory Chat.fromJson(dynamic json) {
    return Chat(
        id: json['_id'] as String,
        name: json['name'] as String,
        messages: json['messages'].toString().contains('{')
            ? ChatMessage.chatMessageFromSnapshot(json['messages'])
            : json['messages'],
        users: json['users'].toString().contains('{')
            ? User.usersFromSnapshot(json['users'])
            : json['users']);
  }

  static List<Chat> chatsFromSnapshot(List snapshot) {
    var a = snapshot.map((data) {
      return Chat.fromJson(data);
    }).toList();

    return a;
  }
}
