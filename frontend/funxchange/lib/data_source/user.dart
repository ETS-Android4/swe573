import 'package:funxchange/models/user.dart';

abstract class UserDataSource {
  Future<User> fetchUser(String id);
}