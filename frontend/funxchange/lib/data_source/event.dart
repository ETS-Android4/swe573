import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/user.dart';

abstract class EventDataSource {
  Future<List<Event>> fetchFeed(int limit, int offset);
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset);
}