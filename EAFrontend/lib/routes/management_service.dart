import 'dart:convert';
import 'package:ea_frontend/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class ManagementService {
  static Future<List<Category>> getCategories() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/management/categories';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/management/categories');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Category.categoriesFromSnapshot(data);
  }

  static Future<String> updateUserCategories(
      String id, String categories) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/management/updateCategories/' +
        id;
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/management/updateCategories/' + id);
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
        'content-type': 'application/json',
      },
      body: json.encode(Message.toJson(categories)),
    );
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }
}

class Message {
  final String message;

  const Message({
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] as String,
    );
  }

  @override
  String toString() {
    return message;
  }

  static Map<String, dynamic> toJson(String values) {
    return {'categories': values};
  }
}
