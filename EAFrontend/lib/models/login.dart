class LoginModel {
  String username;
  String password;

  LoginModel({required this.username, required this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        username: json['userName'], password: json['password']);
  }

  static Map<String, dynamic> toJson(LoginModel credentials) {
    return {
      'userName': credentials.username,
      'password': credentials.password,
    };
  }
}
