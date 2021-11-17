import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/event.dart';

class MockEventDataSource implements EventDataSource {
  static Map<String, Event> data = {};

  @override
  Future<List<Event>> fetchFeed(int limit, int offset) {
    return MockUtils.delayed(
        () => data.values.skip(offset).take(limit).toList());
  }
}
