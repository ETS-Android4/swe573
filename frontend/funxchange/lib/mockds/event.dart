import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/new_event.dart';
import 'package:funxchange/models/user.dart';
import 'package:uuid/uuid.dart';

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
        .where((element) =>
            followed ? followedUsers.contains(element.ownerId) : true)
        .skip(offset)
        .take(limit)
        .toList());
  }

  @override
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset) {
    return MockUtils.delayed(
        () => participantGraph[eventId]!.skip(offset).take(limit).toList());
  }

  @override
  Future<List<Event>> fetchEventsOfUser(int limit, int offset, String userId) {
    return MockUtils.delayed(() => data.values
        .where((element) => element.ownerId == userId)
        .skip(offset)
        .take(limit)
        .toList());
  }

  @override
  Future<Event> createEvent(NewEventParams params, String userId) {
    const uuid = Uuid();
    final model = Event(
      uuid.v4(),
      userId,
      params.type,
      params.capacity,
      0,
      params.category,
      params.title,
      params.details,
      params.latitude,
      params.longitude,
      params.cityName,
      params.countryName,
      params.startDateTime.difference(params.endDateTime).inMinutes,
      params.startDateTime,
    );

    data[model.id] = model;
    participantGraph[model.id] = [];
    return MockUtils.delayed(() => model);
  }

  @override
  Future<Event> fetchEvent(String id) {
    return MockUtils.delayed(() => data[id]!);
  }
}
