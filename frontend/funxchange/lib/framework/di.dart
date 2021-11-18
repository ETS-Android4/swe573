import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/repository/event.dart';
import 'package:funxchange/repository/user.dart';

class DIContainer {
  final EventRepository eventRepo;
  final UserRepository userRepo;

  DIContainer._internal(this.eventRepo, this.userRepo);

  static final singleton = DIContainer._internal(
    EventRepository(MockEventDataSource()),
    UserRepository(MockUserDataSource()),
  );
}
