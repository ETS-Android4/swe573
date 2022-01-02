import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/framework/api/funxchange_api.dart';
import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/message.dart';
import 'package:funxchange/mockds/notification.dart';
import 'package:funxchange/mockds/request.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';
import 'package:funxchange/models/message.dart';
import 'package:funxchange/models/new_user.dart';
import 'package:funxchange/models/notification.dart';
import 'package:funxchange/models/request.dart';
import 'package:funxchange/models/user.dart';
import 'package:uuid/uuid.dart';

class MockUtils {
  static Future<T> delayed<T>([FutureOr<T> Function()? computation]) {
    return Future.delayed(const Duration(seconds: 1), computation);
  }

  static void populateData() {
    var faker = Faker();
    var uuid = const Uuid();
    var random = Random();

    var users = List.generate(
      300,
      (index) => User(
        uuid.v4(),
        faker.internet.userName(),
        _mockBio(faker),
        random.nextInt(200),
        0,
        _randomElems(Interest.values,
            random.nextInt(Interest.values.length - 1) + 1, (_) => true),
        false,
        null,
        0,
      ),
    );

    MockUserDataSource.data =
        users.asMap().map((key, value) => MapEntry(value.id, value));

    MockUserDataSource.currentUserId = users.first.id;

    var events = List.generate(users.length * 6, (index) {
      var type = _randomElem(EventType.values);
      var title = type == EventType.meetup
          ? faker.conference.name()
          : faker.job.title();
      var totalCapacity = random.nextInt(6) + 1;
      var participantCount = random.nextInt(totalCapacity);
      return Event(
          uuid.v4(),
          _randomElem(users).id,
          type,
          totalCapacity,
          participantCount,
          _randomElem(Interest.values),
          title,
          faker.lorem.sentences(5).join(" "),
          random.nextDouble() * 150,
          random.nextDouble() * 150,
          faker.address.city(),
          faker.address.country(),
          (random.nextInt(12) + 1) * 30,
          faker.date.dateTime(minYear: 2022, maxYear: 2023),
          true);
    });

    MockEventDataSource.data =
        events.asMap().map((key, value) => MapEntry(value.id, value));

    MockEventDataSource.participantGraph =
        events.asMap().map((key, value) => MapEntry(
              value.id,
              _randomElems(
                  users, value.participantCount, (u) => u.id != value.ownerId),
            ));

    MockUserDataSource.followerGraph =
        users.asMap().map((key, value) => MapEntry(
              value.id,
              _randomElems(users, value.followerCount, (u) => u.id != value.id),
            ));

    MockUserDataSource.data = MockUserDataSource.data.map((key, u) => MapEntry(
        key,
        User(
          u.id,
          u.userName,
          u.bio,
          u.followerCount,
          getFollowedUsers(u.id).length,
          u.interests,
          u.id == MockUserDataSource.currentUserId
              ? null
              : getFollowedUsers(MockUserDataSource.currentUserId)
                  .map((e) => e.id)
                  .contains(u.id),
          null,
          0,
        )));

    final currentUserEvents = MockEventDataSource.data.values
        .where((element) => element.ownerId == MockUserDataSource.currentUserId)
        .toList();

    final joinRequestors = currentUserEvents.asMap().map(
          (key, value) => MapEntry(
            value.id,
            _randomElems<User>(
              MockUserDataSource.data.values.toList(),
              random.nextInt(value.capacity),
              (u) =>
                  u.id != MockUserDataSource.currentUserId &&
                  !MockEventDataSource.participantGraph[value.id]!
                      .map((e) => e.id)
                      .contains(u.id),
            ),
          ),
        );

    final followNotifs = MockUserDataSource
        .followerGraph[MockUserDataSource.currentUserId]!
        .map((e) => _generateFollowerNotification(e))
        .toList();

    final joinRequestNotifs = joinRequestors.keys.map((eventId) {
      final requestorUsers = joinRequestors[eventId]!;
      final currentEvent = MockEventDataSource.data[eventId]!;
      return requestorUsers
          .map((u) => _generateJoinRequestNotification(u, currentEvent))
          .toList();
    }).fold<List<NotificationModel>>(
        [], (previousValue, element) => previousValue + element);

    final joinRequests = joinRequestors.keys.map((eventId) {
      final requestorUsers = joinRequestors[eventId]!;
      final currentEvent = MockEventDataSource.data[eventId]!;

      return requestorUsers
          .map((e) => _generateJoinRequest(e, currentEvent))
          .toList();
    }).fold<List<JoinRequest>>(
        [], (previousValue, element) => previousValue + element);

    joinRequests.shuffle();

    MockJoinRequestDataSource.data = joinRequests;

    final allNotifs = (followNotifs + joinRequestNotifs);
    allNotifs.shuffle();
    MockNotificationDataSource.data = allNotifs;

    MockMessageDataSource.data = generateMockMessages(
      MockUserDataSource.currentUserId,
      users,
      faker,
    );
  }

  static List<Message> generateMockMessages(
    String currentUserId,
    List<User> users,
    Faker faker,
  ) {
    final luckyUsers =
        _randomElems<User>(users, 35, (p0) => p0.id != currentUserId)
            .map((e) => e.id);

    final messages = luckyUsers
        .map((e) => List.generate(faker.randomGenerator.integer(200) + 1, (_) {
              final firstIsSender = faker.randomGenerator.boolean();
              final sender = firstIsSender ? e : currentUserId;
              final receiver = firstIsSender ? currentUserId : e;
              return _mockMessage(faker, sender, receiver);
            }))
        .fold<List<Message>>(
            [], (previousValue, element) => previousValue + element);

    messages.sort((a, b) => b.created.compareTo(a.created));
    return messages;
  }

  static Message _mockMessage(Faker faker, String senderId, String receiverId) {
    final body = _mockMessageText(faker);
    final created = _mockMessageCreationDate(faker);
    final senderUserName = MockUserDataSource.data[senderId]!.userName;
    final receiverUserName = MockUserDataSource.data[receiverId]!.userName;
    return Message(
      senderId,
      receiverId,
      makeConversationId(senderId, receiverId),
      senderUserName,
      receiverUserName,
      body,
      created,
    );
  }

  static DateTime _mockMessageCreationDate(Faker faker) {
    final maxDate = DateTime.now().subtract(const Duration(hours: 1));
    final minDate = maxDate.subtract(const Duration(days: 365));
    final randomMillis = faker.randomGenerator.integer(
          maxDate.millisecondsSinceEpoch ~/ 1000,
          min: minDate.millisecondsSinceEpoch ~/ 1000,
        ) *
        1000;

    return DateTime.fromMillisecondsSinceEpoch(randomMillis);
  }

  static String _mockMessageText(Faker faker) {
    return faker.lorem
        .sentences(faker.randomGenerator.integer(10, min: 1))
        .join(" ");
  }

  static String _mockBio(Faker faker) {
    return faker.job.title() +
        " in " +
        faker.company.name() +
        ". " +
        faker.food.dish() +
        " is my fav of all time!";
  }

  static List<T> _randomElems<T>(
    List<T> list,
    int n,
    bool Function(T) predicate,
  ) {
    var copy = [...list];
    copy.shuffle();
    return copy.where(predicate).take(n).toList();
  }

  static T _randomElem<T>(List<T> list) {
    var copy = [...list];
    copy.shuffle();
    return copy.first;
  }

  static const String _baseDeeplink = "funxchange://";

  static String _generateUserDeeplink(String userId) {
    return _baseDeeplink + "users/" + userId;
  }

  static String _generateEventDeeplink(String eventId) {
    return _baseDeeplink + "events/" + eventId;
  }

  static const String _requestsDeeplink = _baseDeeplink + "requests";

  static String _generateUserHtml(User user) {
    final deeplink = _generateUserDeeplink(user.id);
    return '<a href="$deeplink">${user.userName}</a>';
  }

  static String _generateEventHtml(Event event) {
    final deeplink = _generateEventDeeplink(event.id);
    return '<a href="$deeplink">${event.title}</a>';
  }

  static NotificationModel _generateFollowerNotification(User follower) {
    final deeplink = _generateUserDeeplink(follower.id);
    final text = '${_generateUserHtml(follower)} has just followed you!';
    return NotificationModel(text, deeplink);
  }

  static JoinRequest _generateJoinRequest(User requestor, Event event) {
    final textBase = '${_generateUserHtml(requestor)} would like to ';
    final cont = event.type == EventType.meetup
        ? 'join your meetup ${_generateEventHtml(event)}.'
        : 'take your service ${_generateEventHtml(event)}.';
    return JoinRequest(event.id, requestor.id, textBase + cont);
  }

  static NotificationModel _generateJoinRequestNotification(
    User requestor,
    Event event,
  ) {
    const deeplink = _requestsDeeplink;
    final textBase = '${_generateUserHtml(requestor)} would like to ';
    final cont = event.type == EventType.meetup
        ? 'join your meetup ${_generateEventHtml(event)}.'
        : 'take your service ${_generateEventHtml(event)}.';
    return NotificationModel(textBase + cont, deeplink);
  }

  static List<User> getFollowedUsers(String userId) {
    List<String> followedUserIds = [];
    MockUserDataSource.followerGraph.forEach((key, value) {
      if (value.map((e) => e.id).contains(userId)) followedUserIds.add(key);
    });
    return followedUserIds.map((e) => MockUserDataSource.data[e]!).toList();
  }

  static String makeConversationId(String senderId, String receiverId) {
    return ([senderId, receiverId]..sort()).join("");
  }
}
