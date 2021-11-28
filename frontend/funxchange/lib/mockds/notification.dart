import 'package:funxchange/data_source/notification.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/notification.dart';

class MockNotificationDataSource implements NotificationDataSource {
  static List<NotificationModel> data = [];

  @override
  Future<List<NotificationModel>> fetchNotifications(int limit, int offset) {
    return MockUtils.delayed(() => data.skip(offset).take(limit).toList());
  }
}
