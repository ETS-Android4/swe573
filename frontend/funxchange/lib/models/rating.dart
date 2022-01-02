import 'dart:convert';

import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/user.dart';

class Rating {
  final String id;
  final User user;
  int? rating;
  final Event event;

  Rating(this.id, this.user, this.rating, this.event);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'rating': rating,
      'event': event.toMap(),
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      map['id'] ?? '',
      User.fromMap(map['user']),
      map['rating']?.toInt(),
      Event.fromMap(map['event']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
