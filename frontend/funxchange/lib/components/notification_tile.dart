import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/models/notification.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel model;

  const NotificationTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final document = parse(model.htmlText);
    final span = parseSpans(document);
    return GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(16.0), child: RichText(text: span)),
      onTap: () {
        // TODO: implement deep link
        print(model.deeplink);
      },
    );
  }

  TextSpan parseSpans(dom.Document doc) {
    final nodes = doc.body!.nodes;
    final spans = nodes.map((n) {
      final href = n.attributes["href"];
      return TextSpan(
        text: n.text ?? "",
        style: (href != null)
            ? const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            : const TextStyle(color: Colors.black),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (href != null) {
              // TODO: implement deep link
              print(href);
            }
          },
      );
    }).toList();

    return TextSpan(children: spans);
  }
}
