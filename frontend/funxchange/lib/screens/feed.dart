import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/screens/feed_list.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

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
        body: const TabBarView(
          children: [
            FeedListPage(followed: false),
            FeedListPage(followed: true),
          ],
        ),
      ),
    );
  }
}
