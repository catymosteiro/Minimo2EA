import 'dart:convert';
import 'package:ea_frontend/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class EventService {
  static Future<List<Event>> getEvents() async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Event.eventsFromSnapshot(data);
  }

  static Future<Event> getEvent(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/$id/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Event.fromJson(data);
  }

  static Future<bool> joinEvent(String eventId) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/join/$userId/$eventId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/join/$userId/$eventId');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> leaveEvent(String eventId) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/leave/$userId/$eventId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/leave/$userId/$eventId');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
