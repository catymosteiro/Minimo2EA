class UserPopulate {
  String id;
  String userName;
  String mail;
  String photoURL;

  UserPopulate(
      {required this.id,
      required this.userName,
      required this.mail,
      required this.photoURL});

  factory UserPopulate.fromJson(dynamic json) {
    var userName = json['userName'] as String;
    var mail = json['mail'] as String;
    var photoURL = json['photoURL'] as String;

    var u = UserPopulate(
      id: json['_id'] as String,
      userName: userName,
      mail: mail,
      photoURL: photoURL,
    );
    return u;
  }

  static List<UserPopulate> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return UserPopulate.fromJson(data);
    }).toList();
  }
}
