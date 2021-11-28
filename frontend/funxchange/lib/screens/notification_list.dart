import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/notification.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  static const _pageSize = 20;

  final PagingController<int, NotificationModel> _pagingController =
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
      final newItems = await DIContainer.singleton.notifRepo
          .fetchNotifications(_pageSize, pageKey);
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
    return PagedListView<int, NotificationModel>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
          itemBuilder: (ctx, item, idx) => Text(item.htmlText)),
    );
  }
}
