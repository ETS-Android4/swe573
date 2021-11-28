import 'package:flutter/material.dart';
import 'package:funxchange/models/notification.dart';
import 'package:html/parser.dart';

class NotificationTile extends StatelessWidget {

  final NotificationModel model;

  const NotificationTile({ Key? key, required this.model }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final document = parse(model.htmlText);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(document.body?.text ?? ""),
      ),
      onTap: () {
        // TODO: implement deep link
        print(model.deeplink);
      },
    );
  }
}