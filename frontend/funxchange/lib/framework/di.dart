import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/notification.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/repository/event.dart';
import 'package:funxchange/repository/notification.dart';
import 'package:funxchange/repository/user.dart';

class DIContainer {
  final EventRepository eventRepo;
  final UserRepository userRepo;
  final NotificationRepository notifRepo;

  DIContainer._internal(this.eventRepo, this.userRepo, this.notifRepo);

  static final singleton = DIContainer._internal(
    EventRepository(MockEventDataSource()),
    UserRepository(MockUserDataSource()),
    NotificationRepository(MockNotificationDataSource()),
  );
}
