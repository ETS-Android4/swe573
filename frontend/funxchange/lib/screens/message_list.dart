import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/message.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessageListPage extends StatefulWidget {
  final String conversationId;

  const MessageListPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
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
      final newItems = await DIContainer.singleton.messageRepo
          .fetchMessages(_pageSize, pageKey, widget.conversationId);
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: PagedListView<int, Message>(
          pagingController: _pagingController,
          reverse: true,
          builderDelegate: PagedChildBuilderDelegate<Message>(
              itemBuilder: (ctx, item, idx) => Text(item.created.toString())),
        ));
  }
}
