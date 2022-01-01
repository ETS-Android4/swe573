import 'dart:convert';

import 'package:funxchange/models/interest.dart';

class NewUserParams {
  final String userName;
  final String bio;
  final List<Interest> interests;
  final String password;

  NewUserParams(this.userName, this.bio, this.interests, this.password);

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'bio': bio,
      'interests': interests.map((x) => x.toJsonString).toList(),
      'password': password,
    };
  }

  factory NewUserParams.fromMap(Map<String, dynamic> map) {
    return NewUserParams(
      map['userName'] ?? '',
      map['bio'] ?? '',
      List<Interest>.from(map['interests']?.map((x) => parseInterest(x))),
      map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUserParams.fromJson(String source) =>
      NewUserParams.fromMap(json.decode(source));
}
