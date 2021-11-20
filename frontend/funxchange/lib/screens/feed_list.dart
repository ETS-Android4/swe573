import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/components/feed_tile.dart';
import 'package:funxchange/framework/cache.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedListPage extends StatefulWidget {
  final bool followed;
  const FeedListPage({Key? key, required this.followed}) : super(key: key);

  @override
  _FeedListPageState createState() => _FeedListPageState();
}

class _FeedListPageState extends State<FeedListPage> {
  static const _pageSize = 20;

  final PagingController<int, Event> _pagingController =
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
      final newItems = await DIContainer.singleton.eventRepo
          .fetchFeed(_pageSize, pageKey * _pageSize, widget.followed);
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
    return FutureBuilder<Map<Interest, Uint8List>>(
        future: Cache.interestImageMap(),
        builder: (ctx, imgSnapshot) {
          if (!imgSnapshot.hasData) {
            return const CupertinoActivityIndicator();
          }
          return PagedListView<int, Event>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Event>(
              itemBuilder: (ctx, item, idx) => FeedTile(
                item,
                imgSnapshot.requireData[item.category]!,
              ),
            ),
          );
        });
  }
}
