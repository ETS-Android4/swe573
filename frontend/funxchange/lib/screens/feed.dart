import 'package:flutter/material.dart';
import 'package:funxchange/colors.dart';
import 'package:funxchange/components/feed_tile.dart';
import 'package:funxchange/models/event.dart';

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
            feedPage(),
            feedPage(),
          ],
        ),
      ),
    );
  }

  ListView feedPage() {
    final events = Event.example;
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) => FeedTile(events[index]),
    );
  }
}
