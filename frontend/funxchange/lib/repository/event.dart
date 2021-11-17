import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/models/event.dart';

class EventRepository {
  final EventDataSource dataSource;

  EventRepository(this.dataSource);

  Future<List<Event>> fetchFeed(int limit, int offset) {
    return dataSource.fetchFeed(limit, offset);
  }
}
