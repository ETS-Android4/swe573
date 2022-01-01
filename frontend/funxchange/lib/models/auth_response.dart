import 'dart:convert';

class AuthResponse {
  final String jwt;

  AuthResponse(this.jwt);

  Map<String, dynamic> toMap() {
    return {
      'jwt': jwt,
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      map['jwt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source));
}
