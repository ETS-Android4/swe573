import 'package:flutter/material.dart';

class InterestPickerPage extends StatelessWidget {
  const InterestPickerPage({Key? key}) : super(key: key);

  static const List<String> items = [
    "Golf",
    "Yoga",
    "Painting",
    "Graphic Design"
    // "Computers",
    // "Makeup",
    // "History",
    // "Foreign Languages",
    // "Cars",
    // "Dancing",
    // "Sewing",
    // "Politics",
    // "Cooking",
    // "Video Games",
    // "Partying"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interests'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.done),
      ),
      body: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => FavoriteItemTile(items[index]),
      ),
    );
  }
}

class FavoriteItemTile extends StatelessWidget {
  final String item;

  const FavoriteItemTile(this.item, {Key? key}) : super(key: key);

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
          item,
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
