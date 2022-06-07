import 'dart:convert';
import 'package:ea_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class UserService {
  static Future<User> getUser(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return User.fromJson(data);
  }

  static Future<User> getUserByUserName(String userName) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/getbyusername/$userName';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/getbyusername/$userName');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return User.fromJson(data);
  }

  static Future<List<User>> getUsers() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return User.usersFromSnapshot(data);
  }

  static Future<bool> updateUser(String id, String name, String userName,
      String mail, String birthDate) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/update/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/update/$id');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'name': name,
          'userName': userName,
          'mail': mail,
          'birthDate': birthDate,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> changePassword(
      String id, String password, String old) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/$id');
    }

    final response = await http.post(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'password': password,
          'old': old,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteAccount(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/user/$id');
    }

    final response = await http.delete(
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
