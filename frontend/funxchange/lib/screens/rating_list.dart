import 'package:flutter/material.dart';
import 'package:funxchange/components/rating_tile.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/rating.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RatingList extends StatefulWidget {
  const RatingList({Key? key}) : super(key: key);

  @override
  _RatingListState createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  static const _pageSize = 20;

  final PagingController<int, Rating> _pagingController =
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
      final newItems = await DIContainer.activeSingleton.ratingRepo
          .fetchRatings(_pageSize, pageKey);
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
    return PagedListView<int, Rating>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Rating>(
        itemBuilder: (ctx, item, idx) => RatingTile(model: item),
      ),
    );
  }
}
