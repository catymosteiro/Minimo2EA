class RegisterModel {
  String name;
  String username;
  DateTime birthDate;
  String mail;
  String password;

  RegisterModel({
    required this.name,
    required this.username,
    required this.birthDate,
    required this.mail,
    required this.password
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        name: json['name'],
        username: json['userName'],
        birthDate: json['birthDate'],
        mail: json['mail'],
        password: json['password']
    );
  }

  static Map<String, dynamic> toJson(RegisterModel credentials) {
    return {
      'name': credentials.name,
      'userName': credentials.username,
      'birthDate': credentials.birthDate.toString(),
      'mail': credentials.mail,
      'password': credentials.password,
    };
  }
}
