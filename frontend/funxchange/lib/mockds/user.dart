import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/user.dart';

class MockUserDataSource implements UserDataSource {
  static Map<String, User> data = {};
  static Map<String, List<User>> followerGraph = {};

  @override
  Future<User> fetchUser(String id) {
    return MockUtils.delayed(() => data[id]!);
  }
}
