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
}
