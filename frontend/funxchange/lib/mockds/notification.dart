import 'package:funxchange/data_source/notification.dart';
import 'package:funxchange/models/notification.dart';

class MockNotificationDataSource implements NotificationDataSource {
  @override
  Future<List<Notification>> fetchNotifications(int limit, int offset) {
    // TODO: implement fetchNotifications
    throw UnimplementedError();
  }

}