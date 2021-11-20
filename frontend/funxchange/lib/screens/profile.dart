// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';
import 'package:funxchange/models/user.dart';
import 'package:funxchange/screens/feed_list.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: DIContainer.singleton.userRepo.fetchUser(userId),
        builder: (context, ss) {
          if (!ss.hasData) {
            return const CupertinoActivityIndicator();
          }
          var user = ss.requireData;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.userName),
            ),
            body: ListView(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Followers",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(user.followerCount.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Following",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(user.followedCount.toString()),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Interested in:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: user.interests
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(e.prettyName)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Bio:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(user.bio),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Events:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                FeedList(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    eventFetcher: (limit, offset) => DIContainer
                        .singleton.eventRepo
                        .fetchEventsOfUser(limit, offset, userId)),
              ],
            ),
          );
        });
  }
}
