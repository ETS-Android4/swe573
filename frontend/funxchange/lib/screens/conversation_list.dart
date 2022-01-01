import 'package:flutter/material.dart';
import 'package:funxchange/components/conversation_tile.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/message.dart';
import 'package:funxchange/screens/message_list.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ConversationList extends StatefulWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  static const _pageSize = 20;

  final PagingController<int, Message> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await DIContainer.mockSingleton.messageRepo
          .fetchConversations(_pageSize, pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Message>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Message>(
        itemBuilder: (ctx, item, idx) => ConversationTile(
          message: item,
          onTap: (m) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => MessageListPage(
                    conversationId: m.conversationId,
                    receiverId: m.senderId ==
                            DIContainer.mockSingleton.userRepo.getCurrentUserId()
                        ? m.receiverId
                        : m.senderId)));
          },
        ),
      ),
    );
  }
}
