import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/message.dart';

class ConversationTile extends StatelessWidget {
  final Message message;

  const ConversationTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_determineUserName());
  }

  String _determineUserName() {
    if (DIContainer.singleton.userRepo.getCurrentUserId() == message.senderId) {
      return message.receiverUserName;
    } else {
      return message.senderUserName;
    }
  }
}
