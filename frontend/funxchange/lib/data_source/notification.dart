import 'package:funxchange/models/notification.dart';

abstract class NotificationDataSource {
  Future<List<Notification>> fetchNotifications(int limit, int offset);
}