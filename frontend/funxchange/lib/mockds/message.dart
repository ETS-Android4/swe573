import 'package:funxchange/data_source/message.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/message.dart';

class MockMessageDataSource implements MessageDataSource {
  static List<Message> data = [];

  @override
  Future<List<Message>> fetchConversations(int limit, int offset) {
    final convoIdSet = <String>{};
    return MockUtils.delayed(() => data
        .where((element) => convoIdSet.add(element.conversationId))
        .skip(offset)
        .take(limit)
        .toList());
  }

  @override
  Future<List<Message>> fetchMessages(
    int limit,
    int offset,
    String conversationId,
  ) {
    return MockUtils.delayed(() => data
        .where((element) => element.conversationId == conversationId)
        .skip(offset)
        .take(limit)
        .toList());
  }

  @override
  Future<Message> sendMessage(String text, String receiverId) async {
    final userRepo = DIContainer.mockSingleton.userRepo;
    final currentUserId = userRepo.getCurrentUserId();
    final currentUser = await userRepo.fetchUser(currentUserId);
    final receiverUser = await userRepo.fetchUser(receiverId);
    final convoId = MockUtils.makeConversationId(currentUserId, receiverId);
    final messageModel = Message(
      currentUserId,
      receiverId,
      convoId,
      currentUser.userName,
      receiverUser.userName,
      text,
      DateTime.now(),
    );
    data.insert(0, messageModel);
    return messageModel;
  }
}
