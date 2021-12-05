import 'package:funxchange/models/request.dart';

abstract class JoinRequestDataSource {
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset);
  Future<JoinRequest> acceptJoinRequest(JoinRequest request);
  Future<JoinRequest> rejectJoinRequest(JoinRequest request);
  Future<JoinRequest> createJoinRequest(String eventId, String userId);
}
