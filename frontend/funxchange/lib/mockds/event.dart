import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/user.dart';

class MockEventDataSource implements EventDataSource {
  static Map<String, Event> data = {};
  static Map<String, List<User>> participantGraph = {};

  @override
  Future<List<Event>> fetchFeed(int limit, int offset, bool followed) {
    var followedUsers = followed
        ? MockUtils.getFollowedUsers(MockUserDataSource.currentUserId)
            .map((e) => e.id)
            .toList()
        : [];
    return MockUtils.delayed(() => data.values
        .skip(offset)
        .where((element) =>
            followed ? followedUsers.contains(element.ownerId) : true)
        .take(limit)
        .toList());
  }

  @override
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset) {
    return MockUtils.delayed(
        () => participantGraph[eventId]!.skip(offset).take(limit).toList());
  }
}
