import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/models/userPopulate.dart';

class Comment {
  dynamic user;
  String title;
  String text;
  String type;
  List<dynamic> users;
  dynamic likes;
  dynamic dislikes;

  Comment(
      {required this.user,
      required this.title,
      required this.text,
      required this.type,
      required this.users,
      required this.likes,
      required this.dislikes});

  factory Comment.fromJson(dynamic json) {
    return Comment(
        user: json['user'].toString().contains('{')
            ? UserPopulate.fromJson(json['user'])
            : json['user'],
        title: json['title'] as String,
        text: json['text'] as String,
        type: json['type'] as String,
        users: json['users'],
        likes: json['likes'].toString(),
        dislikes: json['dislikes'].toString());
  }

  static Map<String, dynamic> toJson(Comment values) {
    return {
      'user': values.user,
      'title': values.title,
      'text': values.text,
      'type': values.type,
      'users': values.users,
      'likes': values.likes,
      'dislikes': values.dislikes
    };
  }

  static List<Comment> commentsFromSnapshot(List snapshot) {
    var a = snapshot.map((data) {
      return Comment.fromJson(data);
    }).toList();

    return a;
  }
}

class UserLikes {
  String id;
  String userName;
  bool like;

  UserLikes(this.id, this.userName, this.like);
}
