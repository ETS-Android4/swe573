import 'package:funxchange/models/event.dart';

abstract class EventDataSource {
  Future<List<Event>> fetchFeed(int limit, int offset);
}