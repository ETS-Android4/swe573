import 'package:funxchange/models/user.dart';

abstract class UserDataSource {
  Future<User> fetchUser(String id);
  Future<List<User>> fetchFollowed(int limit, int offset, String userId);
  Future<List<User>> fetchFollowers(int limit, int offset, String userId);
  String getCurrentUserId();
  Future<String> followUser(String userId);
  Future<String> unfollowUser(String userId);
  Future<User> fetchUserByUserName(String userName);
}
