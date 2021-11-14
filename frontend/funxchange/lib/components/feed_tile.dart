import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/colors.dart';
import 'package:funxchange/models/event.dart';

class FeedTile extends StatelessWidget {
  final Event item;

  const FeedTile(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const height = 200.0;
    return Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.type == EventType.meetup
                ? const Icon(Icons.groups_outlined)
                : const Icon(Icons.hail_outlined),
            BorderedText(
              strokeWidth: 1.0,
              child: Text(
                item.title,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            BorderedText(
              strokeWidth: 1.0,
              child: Text(
                item.location,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            BorderedText(
              strokeWidth: 1.0,
              child: Text(
                item.dateTime.toString().replaceAll(":00.000", ""),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: BorderedText(
                strokeWidth: 1.0,
                child: Text(
                  item.details,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25),
                  BlendMode.srcOver,
                ),
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover)));
  }
}
