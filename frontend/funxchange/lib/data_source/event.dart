import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/new_event.dart';
import 'package:funxchange/models/user.dart';

abstract class EventDataSource {
  Future<List<Event>> fetchFeed(int limit, int offset, bool followed);
  Future<List<Event>> fetchEventsOfUser(int limit, int offset, String userId);
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset);
  Future<Event> createEvent(NewEventParams params, String userId);
}
