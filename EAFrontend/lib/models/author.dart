import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/models/userPopulate.dart';

import 'book.dart';
import 'user.dart';
import 'category.dart' as myCategory;
import 'dart:developer';

class Author {
  String id;
  String name;
  DateTime birthDate;
  DateTime deathDate;
  String biography;
  List<dynamic> books;
  List<dynamic> categories;
  String photoURL;
  UserPopulate user;

  Author(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.deathDate,
      required this.biography,
      required this.books,
      required this.categories,
      required this.photoURL,
      required this.user});

  factory Author.fromJson(dynamic json) {
    var id = json['_id'] as String;
    var name = json['name'] as String;
    var birthDate =
        DateTime.parse((json['birthDate'] as String).replaceAll("T", " "));
    var deathDate =
        DateTime.parse((json['deathDate'] as String).replaceAll("T", " "));
    var biography = json['biography'] as String;
    var categories = json['categories'].toString().contains('{')
        ? Category.categoriesFromSnapshot(json['categories'])
        : json['categories'];
    var photoURL = json['photoURL'] as String;
    var user = UserPopulate.fromJson(json['user']);
    var books = json['books'].toString().contains('{')
        ? BookPopulate.booksPopulateFromSnapshot(json['books'])
        : json['books'];

    var author = Author(
        id: id,
        name: name,
        deathDate: deathDate,
        birthDate: birthDate,
        biography: biography,
        books: books,
        categories: categories,
        photoURL: photoURL,
        user: user);
    return author;
  }

  static List<Author> authorsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Author.fromJson(data);
    }).toList();
  }
}

class BookPopulate {
  String id;
  String title;
  DateTime publishedDate;

  BookPopulate(
      {required this.id, required this.title, required this.publishedDate});

  factory BookPopulate.fromJson(dynamic json) {
    var id = json['_id'] as String;
    var title = json['title'] as String;
    var publishedDate =
        DateTime.parse((json['publishedDate'] as String).replaceAll("T", " "));

    var book = BookPopulate(
      id: id,
      title: title,
      publishedDate: publishedDate,
    );
    return book;
  }
  static List<BookPopulate> booksPopulateFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return BookPopulate.fromJson(data);
    }).toList();
  }
}
