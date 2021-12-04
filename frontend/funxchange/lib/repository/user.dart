import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/models/user.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository(this.dataSource);

  Future<User> fetchUser(String id) {
    return dataSource.fetchUser(id);
  }

  Future<List<User>> fetchFollowers(int limit, int offset, String userId) {
    return dataSource.fetchFollowers(limit, offset, userId);
  }

  Future<List<User>> fetchFollowed(int limit, int offset, String userId) {
    return dataSource.fetchFollowed(limit, offset, userId);
  }

  String getCurrentUserId() {
    return dataSource.getCurrentUserId();
  }
}
