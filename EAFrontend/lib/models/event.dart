import 'package:ea_frontend/models/userPopulate.dart';

import 'location.dart';
import 'user.dart';
import 'category.dart';
import 'chat.dart';

class Event {
  String id;
  String name;
  String description;
  Location location;
  dynamic admin;
  dynamic chat;
  DateTime eventDate;
  List<dynamic> usersList;
  List<dynamic> category;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      required this.admin,
      required this.chat,
      required this.eventDate,
      required this.usersList,
      required this.category});

  factory Event.fromJson(dynamic json) {
    return Event(
        id: json['_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        location: Location.fromJson(json['location']),
        admin: json['admin'].toString().contains('{')
            ? UserPopulate.fromJson(json['admin'])
            : json['admin'],
        chat: json['chat'].toString().contains('{')
            ? Chat.fromJson(json['chat'])
            : json['chat'],
        eventDate:
            DateTime.parse((json['eventDate'] as String).replaceAll("T", " ")),
        usersList: json['usersList'].toString().contains('{')
            ? UserPopulate.usersFromSnapshot(json['usersList'])
            : json['usersList'],
        category: json['category'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['category'])
            : json['category']);
  }

  static List<Event> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Event.fromJson(data);
    }).toList();
  }
}
