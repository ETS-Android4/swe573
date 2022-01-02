import 'dart:typed_data';

import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:funxchange/components/user_snapshot.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/screens/user_list.dart';

class EventPage extends StatefulWidget {
  final Event event;
  final Uint8List image;

  const EventPage({Key? key, required this.event, required this.image})
      : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  var _joinable = false;

  @override
  void initState() {
    _joinable = widget.event.joinable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(widget.image),
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
                  widget.event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 6),
                Text(widget.event.type.prettyString),
                const SizedBox(height: 6),
                const Text("Created by: "),
                const SizedBox(height: 6),
                UserSnapshot(userFetcher: dz.Left(widget.event.ownerId)),
                const SizedBox(height: 6),
                Text(widget.event.cityName + " - " + widget.event.countryName),
                const SizedBox(height: 6),
                Text(widget.event.details),
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
                          Utils.formatDateTime(widget.event.dateTime),
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
                          Utils.formatDateTime(widget.event.dateTime.add(
                              Duration(
                                  minutes: widget.event.durationInMinutes))),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Capacity: " +
                    widget.event.capacity.toString() +
                    " people"),
                MaterialButton(
                  height: 10,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => UserListPage(
                          userFetcher: (limit, offset) => DIContainer
                              .activeSingleton.eventRepo
                              .fetchParticipants(
                                  widget.event.id, limit, offset),
                          title: "Participants"),
                    ));
                  },
                  child: Text(
                    "PARTICIPANTS (" +
                        widget.event.participantCount.toString() +
                        ")",
                  ),
                ),
                if (_joinable)
                  MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    color: FunColor.fulvous,
                    child: const Text("JOIN EVENT"),
                    onPressed: () {
                      setState(() {
                        _joinable = false;
                      });
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(
                        const SnackBar(
                            content: Text('Creating join request...')),
                      );

                      DIContainer.activeSingleton.joinRequestRepo
                          .createJoinRequest(
                              widget.event.id,
                              DIContainer.activeSingleton.userRepo
                                  .getCurrentUserId())
                          .then((value) {
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('Created join request.')),
                        );
                        setState(() {
                          _joinable = false;
                        });
                      }).onError((error, _) {
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                            SnackBar(content: Text(error.toString())));
                        setState(() {
                          _joinable = true;
                        });
                      });
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
