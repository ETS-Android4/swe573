import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/models/user.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository(this.dataSource);

  Future<User> fetchUser(String id) {
    return dataSource.fetchUser(id);
  }
}
