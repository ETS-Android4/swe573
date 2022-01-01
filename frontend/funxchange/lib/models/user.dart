import 'dart:convert';

import 'package:funxchange/models/credit_score.dart';
import 'package:funxchange/models/interest.dart';

class User {
  final String id;
  final String userName;
  final String bio;
  final int followerCount;
  final int followedCount;
  final List<Interest> interests;
  final CreditScore? creditScore;
  final double ratingAvg;
  bool? isFollowed;

  User(this.id, this.userName, this.bio, this.followerCount, this.followedCount,
      this.interests, this.isFollowed, this.creditScore, this.ratingAvg);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'bio': bio,
      'followerCount': followerCount,
      'followedCount': followedCount,
      'interests': interests.map((x) => x.toJsonString).toList(),
      'creditScore': creditScore?.toMap(),
      'ratingAvg': ratingAvg,
      'isFollowed': isFollowed,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'] ?? '',
      map['userName'] ?? '',
      map['bio'] ?? '',
      map['followerCount']?.toInt() ?? 0,
      map['followedCount']?.toInt() ?? 0,
      List<Interest>.from(map['interests']?.map((x) => parseInterest(x)!)),
      map['isFollowed'],
      map['creditScore'] != null
          ? CreditScore.fromMap(map['creditScore'])
          : null,
      map['ratingAvg']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
