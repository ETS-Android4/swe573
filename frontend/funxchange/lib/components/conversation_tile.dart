import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationTile extends StatelessWidget {
  final Message message;
  final Function(Message) onTap;

  const ConversationTile({Key? key, required this.message, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => onTap(message),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _determineUserName(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(message.senderUserName + ": " + message.text,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(
                  timeago.format(message.created, locale: 'en_short'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _determineUserName() {
    if (DIContainer.singleton.userRepo.getCurrentUserId() == message.senderId) {
      return message.receiverUserName;
    } else {
      return message.senderUserName;
    }
  }
}
