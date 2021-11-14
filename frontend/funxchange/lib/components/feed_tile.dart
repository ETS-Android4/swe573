import 'package:flutter/material.dart';
import 'package:funxchange/models/event.dart';

class FeedTile extends StatelessWidget {
  final Event item;

  const FeedTile(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.primaries[item.hashCode % Colors.primaries.length],
        ),
        title: Text(
          item.title,
          key: Key('favorites_text_$item'),
        ),
        trailing: IconButton(
          key: Key('icon_$item'),
          icon: const Icon(Icons.favorite_border),
          onPressed: () {},
        ),
      ),
    );
  }
}
