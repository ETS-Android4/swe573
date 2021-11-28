import 'package:funxchange/models/request.dart';

abstract class JoinRequestDataSource {
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset);
}