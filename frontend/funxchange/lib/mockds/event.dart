import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/models/event.dart';

class MockEventDataSource implements EventDataSource {
  @override
  Future<List<Event>> fetchFeed(int limit, int offset) {
    // TODO: implement fetchFeed
    throw UnimplementedError();
  }
  
}