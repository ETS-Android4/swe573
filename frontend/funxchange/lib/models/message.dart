class Message {
  final String senderId;
  final String receiverId;
  final String conversationId;
  final String senderUserName;
  final String text;
  final DateTime created;

  Message(
    this.senderId,
    this.receiverId,
    this.conversationId,
    this.senderUserName,
    this.text,
    this.created,
  );
}
