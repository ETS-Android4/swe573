import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom;

class Utils {
  static String formatDateTime(DateTime dateTime) {
    var format = DateFormat.yMEd().add_Hm();
    return format.format(dateTime);
  }

  static TextSpan parseSpans(dom.Document doc, String? deeplink) {
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
            } else {
              print(deeplink);
            }
          },
      );
    }).toList();

    return TextSpan(children: spans);
  }
}
