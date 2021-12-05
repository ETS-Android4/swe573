import 'package:funxchange/data_source/message.dart';
import 'package:funxchange/models/message.dart';

class MessageRepository {
  final MessageDataSource dataSource;

  MessageRepository(this.dataSource);

  Future<List<Message>> fetchConversations(
    int limit,
    int offset,
  ) =>
      dataSource.fetchConversations(limit, offset);

  Future<List<Message>> fetchMessages(
    int limit,
    int offset,
    String conversationId,
  ) =>
      dataSource.fetchMessages(limit, offset, conversationId);

  Future<Message> sendMessage(
    String text,
    String receiverId,
  ) =>
      dataSource.sendMessage(text, receiverId);
}
