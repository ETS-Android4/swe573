import 'dart:convert';

import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';

class NewEventParams {
  final EventType type;
  final int capacity;
  final Interest category;
  final String title;
  final String details;
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final DateTime endDateTime;
  final DateTime startDateTime;

  NewEventParams(
    this.type,
    this.capacity,
    this.category,
    this.title,
    this.details,
    this.latitude,
    this.longitude,
    this.cityName,
    this.countryName,
    this.endDateTime,
    this.startDateTime,
  );

  Map<String, dynamic> toMap() {
    return {
      'type': type.toJsonString,
      'capacity': capacity,
      'category': category.toJsonString,
      'title': title,
      'details': details,
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'countryName': countryName,
      'endDateTime': endDateTime.toIso8601String(),
      'startDateTime': startDateTime.toIso8601String()
    };
  }

  factory NewEventParams.fromMap(Map<String, dynamic> map) {
    return NewEventParams(
      parseEventType(map['type'])!,
      map['capacity']?.toInt() ?? 0,
      parseInterest(map['category'])!,
      map['title'] ?? '',
      map['details'] ?? '',
      map['latitude']?.toDouble() ?? 0.0,
      map['longitude']?.toDouble() ?? 0.0,
      map['cityName'] ?? '',
      map['countryName'] ?? '',
      DateTime.parse(map['endDateTime']),
      DateTime.parse(map['startDateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewEventParams.fromJson(String source) =>
      NewEventParams.fromMap(json.decode(source));
}
