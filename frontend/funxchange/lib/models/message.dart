import 'dart:convert';

class Message {
  final String senderId;
  final String receiverId;
  final String conversationId;
  final String senderUserName;
  final String receiverUserName;
  final String text;
  final DateTime created;

  Message(
    this.senderId,
    this.receiverId,
    this.conversationId,
    this.senderUserName,
    this.receiverUserName,
    this.text,
    this.created,
  );

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'conversationId': conversationId,
      'senderUserName': senderUserName,
      'receiverUserName': receiverUserName,
      'text': text,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['senderId'] ?? '',
      map['receiverId'] ?? '',
      map['conversationId'] ?? '',
      map['senderUserName'] ?? '',
      map['receiverUserName'] ?? '',
      map['text'] ?? '',
      DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
