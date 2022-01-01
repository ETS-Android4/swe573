import 'package:funxchange/framework/api/funxchange_api.dart';
import 'package:funxchange/framework/api/geocoding.dart';
import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/message.dart';
import 'package:funxchange/mockds/notification.dart';
import 'package:funxchange/mockds/request.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/repository/auth.dart';
import 'package:funxchange/repository/event.dart';
import 'package:funxchange/repository/geocoding.dart';
import 'package:funxchange/repository/message.dart';
import 'package:funxchange/repository/notification.dart';
import 'package:funxchange/repository/request.dart';
import 'package:funxchange/repository/user.dart';

class DIContainer {
  final EventRepository eventRepo;
  final UserRepository userRepo;
  final NotificationRepository notifRepo;
  final JoinRequestRepository joinRequestRepo;
  final GeocodingRepository geocodingRepo;
  final MessageRepository messageRepo;
  final AuthRepository authRepo;

  DIContainer._internal(
    this.eventRepo,
    this.userRepo,
    this.notifRepo,
    this.joinRequestRepo,
    this.geocodingRepo,
    this.messageRepo,
    this.authRepo,
  );

  static final _geocodingApiDataSource = GeocodingApiDataSource();
  static final _apiDataSource = FunxchangeApiDataSource.singleton;

  static final mockSingleton = DIContainer._internal(
    EventRepository(MockEventDataSource()),
    UserRepository(MockUserDataSource()),
    NotificationRepository(MockNotificationDataSource()),
    JoinRequestRepository(MockJoinRequestDataSource()),
    GeocodingRepository(_geocodingApiDataSource),
    MessageRepository(MockMessageDataSource()),
    AuthRepository(_apiDataSource),
  );

  static final singleton = DIContainer._internal(
    EventRepository(_apiDataSource),
    UserRepository(_apiDataSource),
    NotificationRepository(_apiDataSource),
    JoinRequestRepository(_apiDataSource),
    GeocodingRepository(_geocodingApiDataSource),
    MessageRepository(_apiDataSource),
    AuthRepository(_apiDataSource),
  );
}
