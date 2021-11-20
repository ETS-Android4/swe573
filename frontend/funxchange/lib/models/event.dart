import 'package:funxchange/models/interest.dart';

class Event {
  final String id;
  final String ownerId;
  final EventType type;
  final int capacity;
  final int participantCount;
  final Interest category;
  final String title;
  final String details;
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final int durationInMinutes;
  final DateTime dateTime;

  Event(
      this.id,
      this.ownerId,
      this.type,
      this.capacity,
      this.participantCount,
      this.category,
      this.title,
      this.details,
      this.latitude,
      this.longitude,
      this.cityName,
      this.countryName,
      this.durationInMinutes,
      this.dateTime);
}

enum EventType {
  meetup,
  service,
}

extension PrettyString on EventType {
  String get prettyString {
    switch (this) {
      case EventType.meetup:
        return "MEETUP";
      case EventType.service:
        return "SERVICE";
    }
  }
}