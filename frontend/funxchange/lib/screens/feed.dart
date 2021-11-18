import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/colors.dart';
import 'package:funxchange/components/feed_tile.dart';
import 'package:funxchange/framework/cache.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/mockds/event.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  static const _pageSize = 20;

  final PagingController<int, Event> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await DIContainer.singleton.eventRepo
          .fetchFeed(_pageSize, pageKey * _pageSize);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.filter_alt,
                    size: 26.0,
                  ),
                )),
          ],
          bottom: const TabBar(
            indicatorColor: FunColor.sunray,
            tabs: [
              Tab(
                text: "Everyone",
              ),
              Tab(
                text: "Followed",
              ),
            ],
          ),
          title: const Text('Feed'),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<Map<Interest, Uint8List>>(
                future: Cache.interestImageMap(),
                builder: (ctx, imgSnapshot) {
                  if (!imgSnapshot.hasData)
                    return const CupertinoActivityIndicator();
                  return PagedListView<int, Event>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Event>(
                      itemBuilder: (ctx, item, idx) => FeedTile(
                        item,
                        imgSnapshot.requireData[item.category]!,
                      ),
                    ),
                  );
                }),
            feedPage(),
          ],
        ),
      ),
    );
  }

  ListView feedPage() {
    final events = [];
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) => Container(),
    );
  }
}
