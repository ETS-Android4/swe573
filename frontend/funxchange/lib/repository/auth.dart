import 'package:funxchange/data_source/auth.dart';
import 'package:funxchange/models/auth_params.dart';
import 'package:funxchange/models/auth_response.dart';
import 'package:funxchange/models/new_user.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<AuthResponse> authenticate(AuthParams params) {
    return _dataSource.authenticate(params);
  }

  Future<AuthResponse> signUp(NewUserParams params) {
    return _dataSource.signUp(params);
  }
}
