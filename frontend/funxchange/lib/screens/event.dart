import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/event.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final Uint8List image;

  const EventPage({Key? key, required this.event, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Column(
        children: [
          Image(image: MemoryImage(image), fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(event.type.prettyString),
                const SizedBox(height: 10),
                Text(event.details),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Starts at",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Utils.formatDateTime(event.dateTime),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Ends at",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Utils.formatDateTime(event.dateTime
                              .add(Duration(minutes: event.durationInMinutes))),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
