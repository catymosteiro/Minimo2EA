class NewChatModel {
  String name;
  List<String> userIds;

  NewChatModel({required this.name, required this.userIds});

  factory NewChatModel.fromJson(Map<String, dynamic> json) {
    return NewChatModel(name: json['name'], userIds: json['userIds']);
  }

  static Map<String, dynamic> toJson(NewChatModel values) {
    return {'name': values.name, 'userIds': values.userIds};
  }
}

class UserList {
  String id;
  String userName;
  bool isSlected;

  UserList(this.id, this.userName, this.isSlected);
}
