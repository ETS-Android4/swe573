import 'package:funxchange/models/interest.dart';

class User {
  final String id;
  final String userName;
  final String bio;
  final int followerCount;
  final int followedCount;
  final List<Interest> interests;

  User(this.id, this.userName, this.bio, this.followerCount, this.followedCount, this.interests);
}
