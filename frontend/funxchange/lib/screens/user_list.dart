import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:funxchange/components/user_snapshot.dart';
import 'package:funxchange/models/user.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserListPage extends StatefulWidget {
  final Future<List<User>> Function(int limit, int offset) userFetcher;
  final String title;

  const UserListPage({Key? key, required this.userFetcher, required this.title})
      : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  static const _pageSize = 20;

  final PagingController<int, User> _pagingController =
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
      final newItems = await widget.userFetcher(_pageSize, pageKey * _pageSize);
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
        title: Text(widget.title),
      ),
      body: PagedListView<int, User>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<User>(
            itemBuilder: (ctx, item, idx) =>
                UserSnapshot(userFetcher: dz.Right(item))),
      ),
    );
  }
}
