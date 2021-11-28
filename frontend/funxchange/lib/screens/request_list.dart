import 'package:flutter/material.dart';
import 'package:funxchange/components/request_tile.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/request.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  static const _pageSize = 20;

  final PagingController<int, JoinRequest> _pagingController =
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
      final newItems = await DIContainer.singleton.joinRequestRepo
          .fetchJoinRequests(_pageSize, pageKey);
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
    return PagedListView<int, JoinRequest>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<JoinRequest>(
        itemBuilder: (ctx, item, idx) => JoinRequestTile(
          model: item,
        ),
      ),
    );
  }
}
