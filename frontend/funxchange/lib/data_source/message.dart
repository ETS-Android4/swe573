import 'package:funxchange/models/message.dart';

abstract class MessageDataSource {
  Future<List<Message>> fetchConversations(int limit, int offset);
  Future<List<Message>> fetchMessages(
      int limit, int offset, String conversationId);
  Future<Message> sendMessage(String text, String receiverId);
}
