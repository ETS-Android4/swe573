import 'dart:convert';

class JoinRequest {
  final String eventId;
  final String userId;
  final String htmlText;

  JoinRequest(this.eventId, this.userId, this.htmlText);

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'htmlText': htmlText,
    };
  }

  factory JoinRequest.fromMap(Map<String, dynamic> map) {
    return JoinRequest(
      map['eventId'] ?? '',
      map['userId'] ?? '',
      map['htmlText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinRequest.fromJson(String source) =>
      JoinRequest.fromMap(json.decode(source));
}
