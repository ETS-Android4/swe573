import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/models/user.dart';

class MockUserDataSource implements UserDataSource {

  @override
  Future<User> fetchUser(String id) {
    // TODO: implement fetchUser
    throw UnimplementedError();
  }
  
}