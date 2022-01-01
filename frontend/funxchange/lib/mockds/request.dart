import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/framework/di.dart';
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

  @override
  Future<JoinRequest> createJoinRequest(String eventId, String userId) async {
    final eventRepo = DIContainer.mockSingleton.eventRepo;
    final event = await eventRepo.fetchEvent(eventId);
    if (event.participantCount >= event.capacity) {
      throw Exception("Event is already full.");
    }

    final participantList =
        await eventRepo.fetchParticipants(eventId, event.capacity, 0);

    if (event.ownerId == userId ||
        participantList.any((element) => element.id == userId)) {
      throw Exception("You have already joined.");
    }

    return JoinRequest(eventId, userId, "");
  }
}
