import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/user.dart';

class EventRepository {
  final EventDataSource dataSource;

  EventRepository(this.dataSource);

  Future<List<Event>> fetchFeed(int limit, int offset, bool followed) {
    return dataSource.fetchFeed(limit, offset, followed);
  }

  Future<List<User>> fetchParticipants(String eventId, int limit, int offset) {
    return dataSource.fetchParticipants(eventId, limit, offset);
  }

  Future<List<Event>> fetchEventsOfUser(int limit, int offset, String userId) {
    return dataSource.fetchEventsOfUser(limit, offset, userId);
  }
}
