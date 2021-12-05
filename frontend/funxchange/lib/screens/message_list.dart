import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/components/message_tile.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/message.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessageListPage extends StatefulWidget {
  final String conversationId;
  final String receiverId;

  const MessageListPage(
      {Key? key, required this.conversationId, required this.receiverId})
      : super(key: key);

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  static const _pageSize = 20;

  final PagingController<int, Message> _pagingController =
      PagingController(firstPageKey: 0);

  final _textController = TextEditingController();
  bool _isLoading = false;

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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PagedListView<int, Message>(
                    pagingController: _pagingController,
                    reverse: true,
                    builderDelegate: PagedChildBuilderDelegate<Message>(
                      itemBuilder: (ctx, item, idx) =>
                          MessageTile(message: item),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                      ),
                    ),
                    MaterialButton(
                        child: _isLoading
                            ? const CupertinoActivityIndicator()
                            : const Icon(Icons.send),
                        onPressed: () {
                          final text = _textController.text;
                          if (text.isEmpty || _isLoading) return;
                          _textController.clear();
                          setState(() {
                            _isLoading = true;
                          });
                          DIContainer.singleton.messageRepo
                              .sendMessage(text, widget.receiverId)
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            _pagingController.refresh();
                          });
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
