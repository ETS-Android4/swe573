import 'package:funxchange/data_source/notification.dart';
import 'package:funxchange/models/notification.dart';

class NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepository(this.dataSource);

  Future<List<NotificationModel>> fetchNotifications(int limit, int offset) {
    return dataSource.fetchNotifications(limit, offset);
  }
}
