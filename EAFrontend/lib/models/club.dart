import 'package:ea_frontend/models/userPopulate.dart';
import 'user.dart';
import 'chat.dart';
import 'category.dart';

class Club {
  String id;
  String name;
  String description;
  dynamic admin;
  dynamic chat;
  List<dynamic> usersList;
  List<dynamic> category;

  Club(
      {required this.id,
      required this.name,
      required this.description,
      required this.admin,
      required this.chat,
      required this.usersList,
      required this.category});

  factory Club.fromJson(dynamic json) {
    return Club(
        id: json['_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        admin: json['admin'].toString().contains('{')
            ? UserPopulate.fromJson(json['admin'])
            : json['admin'],
        chat: json['chat'].toString().contains('{')
            ? Chat.fromJson(json['chat'])
            : json['chat'],
        usersList: json['usersList'].toString().contains('{')
            ? UserPopulate.usersFromSnapshot(json['usersList'])
            : json['usersList'],
        category: json['category'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['category'])
            : json['category']);
  }

  static List<Club> clubsFromSnapshot(List snapshot) {
    var list = snapshot.map((data) {
      return Club.fromJson(data);
    }).toList();
    return list;
  }
}
