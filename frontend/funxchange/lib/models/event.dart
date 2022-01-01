import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'type': type.toJsonString,
      'capacity': capacity,
      'participantCount': participantCount,
      'category': category.toJsonString,
      'title': title,
      'details': details,
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'countryName': countryName,
      'durationInMinutes': durationInMinutes,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['id'] ?? '',
      map['ownerId'] ?? '',
      parseEventType(map['type'])!,
      map['capacity']?.toInt() ?? 0,
      map['participantCount']?.toInt() ?? 0,
      parseInterest(map['category'])!,
      map['title'] ?? '',
      map['details'] ?? '',
      map['latitude']?.toDouble() ?? 0.0,
      map['longitude']?.toDouble() ?? 0.0,
      map['cityName'] ?? '',
      map['countryName'] ?? '',
      map['durationInMinutes']?.toInt() ?? 0,
      DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}

enum EventType {
  meetup,
  service,
}

EventType? parseEventType(String value) {
  return EventType.values.firstWhere((element) => element.toJsonString == value);
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

  String get toJsonString {
    return toString().replaceAll("EventType.", "");
  }
}
