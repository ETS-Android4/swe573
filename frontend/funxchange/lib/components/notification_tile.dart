import 'package:flutter/material.dart';
import 'package:funxchange/framework/deeplink.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/notification.dart';
import 'package:html/parser.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel model;

  const NotificationTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final document = parse(model.htmlText);
    final span = Utils.parseSpans(document, model.deeplink, (deeplink) {
      DeeplinkNavigator.of(context).navigate(deeplink);
    });
    return Padding(
      child: RichText(text: span),
      padding: const EdgeInsets.all(16.0),
    );
  }
}
