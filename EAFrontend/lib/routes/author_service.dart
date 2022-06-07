import 'dart:convert';
import 'package:ea_frontend/models/author.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class AuthorService {
  static Future<dynamic> getAuthor(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      return Author.fromJson(data);
    }
    return null;
  }

  static Future<List<Author>> getAuthors() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return Author.authorsFromSnapshot(data);
  }

  static Future<bool> postAuthor(
      String id,
      String name,
      String biography,
      String mail,
      String birthDate,
      String deathDate,
      String category,
      String photoURL) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/');
    }

    final response = await http.post(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'userId': id,
          'name': name,
          'birthDate': birthDate,
          'deathDate': deathDate,
          'biography': biography,
          'category': category,
          'photoURL': photoURL
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> updateAuthor(
      String id,
      String name,
      String biography,
      String birthDate,
      String deathDate,
      //String category,
      String photoURL) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/$id');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'name': name,
          'birthDate': birthDate,
          'deathDate': deathDate,
          'biography': biography,
          //'category': category,
          'photoURL': photoURL
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteBook(String bookId, String authorId) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/delBook/';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/delBook/');
    }

    final response = await http.post(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'authorId': authorId,
          'bookId': bookId,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> addBook(String bookId, String authorId) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'authorId': authorId,
          'bookId': bookId,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteAuthor(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/author/$id';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/author/$id');
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
