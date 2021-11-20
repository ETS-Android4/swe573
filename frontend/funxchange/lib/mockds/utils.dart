import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';
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
      200,
      (index) => User(
        uuid.v4(),
        faker.internet.userName(),
        _mockBio(faker),
        random.nextInt(300),
        random.nextInt(300),
        _randomElems(
            Interest.values, random.nextInt(Interest.values.length - 1) + 1),
        false,
      ),
    );

    MockUserDataSource.data =
        users.asMap().map((key, value) => MapEntry(value.id, value));

    var events = List.generate(users.length * 6, (index) {
      var type = _randomElem(EventType.values);
      var title = type == EventType.meetup
          ? faker.conference.name()
          : faker.job.title();
      return Event(
          uuid.v4(),
          _randomElem(users).id,
          type,
          random.nextInt(6),
          _randomElem(Interest.values),
          title,
          faker.lorem.sentences(5).join(" "),
          random.nextDouble() * 150,
          random.nextDouble() * 150,
          faker.address.city(),
          faker.address.country(),
          (random.nextInt(12) + 1) * 30,
          faker.date.dateTime(minYear: 2022, maxYear: 2023));
    });

    MockEventDataSource.data =
        events.asMap().map((key, value) => MapEntry(value.id, value));
  }

  static String _mockBio(Faker faker) {
    return faker.job.title() +
        " in " +
        faker.company.name() +
        ". " +
        faker.food.dish() +
        " is my fav of all time!";
  }

  static List<T> _randomElems<T>(List<T> list, int n) {
    var copy = [...list];
    copy.shuffle();
    return copy.take(n).toList();
  }

  static T _randomElem<T>(List<T> list) {
    var copy = [...list];
    copy.shuffle();
    return copy.first;
  }
}
