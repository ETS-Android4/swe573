import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/user.dart';

class MockUserDataSource implements UserDataSource {
  static Map<String, User> data = {};
  static Map<String, List<User>> followerGraph = {};
  static String currentUserId = "";

  @override
  Future<User> fetchUser(String id) {
    return MockUtils.delayed(() => data[id]!);
  }

  @override
  Future<List<User>> fetchFollowed(int limit, int offset, String userId) {
    return MockUtils.delayed(() =>
        MockUtils.getFollowedUsers(userId).skip(offset).take(limit).toList());
  }

  @override
  Future<List<User>> fetchFollowers(int limit, int offset, String userId) {
    return MockUtils.delayed(
        () => followerGraph[userId]!.skip(offset).take(limit).toList());
  }
}
