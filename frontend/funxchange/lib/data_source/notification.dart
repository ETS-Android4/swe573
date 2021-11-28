import 'package:funxchange/models/notification.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> fetchNotifications(int limit, int offset);
}