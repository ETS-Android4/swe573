import 'dart:convert';

class NotificationModel {
  final String htmlText;
  final String deeplink;

  NotificationModel(this.htmlText, this.deeplink);

  Map<String, dynamic> toMap() {
    return {
      'htmlText': htmlText,
      'deeplink': deeplink,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      map['htmlText'] ?? '',
      map['deeplink'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
