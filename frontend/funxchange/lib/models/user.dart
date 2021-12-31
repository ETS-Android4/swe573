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

  User(this.id, this.userName, this.bio, this.followerCount, this.followedCount, this.interests, this.isFollowed, this.creditScore, this.ratingAvg);
}
