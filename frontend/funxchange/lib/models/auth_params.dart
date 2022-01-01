import 'dart:convert';

class AuthParams {
  final String userName;
  final String password;

  AuthParams(this.userName, this.password);

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'password': password,
    };
  }

  factory AuthParams.fromMap(Map<String, dynamic> map) {
    return AuthParams(
      map['userName'] ?? '',
      map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthParams.fromJson(String source) =>
      AuthParams.fromMap(json.decode(source));
}
