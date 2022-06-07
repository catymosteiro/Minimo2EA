import 'dart:developer';

class Category {
  String? name;
  String? id;

  Category({this.name, this.id});

  factory Category.fromJson(dynamic json) {
    if (json.runtimeType == String) {
      return Category(name: null);
    }
    return Category(
      id: json['_id'] as String,
      name: json['name'] == null ? null : json['name'] as String
    );
  }

  static List<Category> categoriesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Category.fromJson(data);
    }).toList();
  }
}
