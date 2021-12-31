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
  final int durationInMinutes;
  final DateTime dateTime;

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
    this.durationInMinutes,
    this.dateTime,
  );

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'capacity': capacity,
      'category': category.toString(),
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
      map['durationInMinutes']?.toInt() ?? 0,
      DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewEventParams.fromJson(String source) =>
      NewEventParams.fromMap(json.decode(source));
}
