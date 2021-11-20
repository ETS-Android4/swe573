import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/components/user_snapshot.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/screens/user_list.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final Uint8List image;

  const EventPage({Key? key, required this.event, required this.image})
      : super(key: key);

  bool _isJoinable() {
    // TODO: implement
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 6),
                Text(event.type.prettyString),
                const SizedBox(height: 6),
                const Text("Created by: "),
                const SizedBox(height: 6),
                UserSnapshot(userFetcher: Left(event.ownerId)),
                const SizedBox(height: 6),
                Text(event.cityName + " - " + event.countryName),
                const SizedBox(height: 6),
                Text(event.details),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Starts at",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
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
                        const SizedBox(height: 6),
                        Text(
                          Utils.formatDateTime(event.dateTime
                              .add(Duration(minutes: event.durationInMinutes))),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Capacity: " + event.capacity.toString() + " people"),
                MaterialButton(
                  height: 10,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => UserListPage(
                          userFetcher: (limit, offset) => DIContainer
                              .singleton.eventRepo
                              .fetchParticipants(event.id, limit, offset),
                          title: "Participants"),
                    ));
                  },
                  child: Text(
                    "PARTICIPANTS (" + event.participantCount.toString() + ")",
                  ),
                ),
                if (_isJoinable())
                  MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    color: FunColor.fulvous,
                    child: const Text("JOIN EVENT"),
                    onPressed: () {
                      // TODO: join event
                    },
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
