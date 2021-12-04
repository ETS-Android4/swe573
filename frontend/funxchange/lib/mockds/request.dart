import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/request.dart';

class MockJoinRequestDataSource implements JoinRequestDataSource {
  static List<JoinRequest> data = [];

  @override
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset) {
    return MockUtils.delayed(() => data.skip(offset).take(limit).toList());
  }

  @override
  Future<JoinRequest> acceptJoinRequest(JoinRequest request) {
    return MockUtils.delayed(() {
      data.removeWhere((element) =>
          element.userId == request.userId &&
          element.eventId == request.eventId);
      MockEventDataSource.participantGraph[request.eventId]!
          .add(MockUserDataSource.data[request.userId]!);
      return request;
    });
  }

  @override
  Future<JoinRequest> rejectJoinRequest(JoinRequest request) {
    return MockUtils.delayed(() {
      data.removeWhere((element) =>
          element.userId == request.userId &&
          element.eventId == request.eventId);
      return request;
    });
  }
}
