import 'package:funxchange/models/auth_params.dart';
import 'package:funxchange/models/auth_response.dart';
import 'package:funxchange/models/new_user.dart';

abstract class AuthDataSource {
  Future<AuthResponse> authenticate(AuthParams params);
  Future<AuthResponse> signUp(NewUserParams params);
}
