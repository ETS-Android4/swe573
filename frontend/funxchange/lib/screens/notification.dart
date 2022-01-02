import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/screens/conversation_list.dart';
import 'package:funxchange/screens/notification_list.dart';
import 'package:funxchange/screens/rating_list.dart';
import 'package:funxchange/screens/request_list.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: FunColor.sunray,
            tabs: [
              Tab(
                text: "Notifications",
              ),
              Tab(
                text: "Requests",
              ),
              Tab(
                text: "Messages",
              ),
              Tab(
                text: "Rate",
              ),
            ],
          ),
          title: const Text('Notifications'),
        ),
        body: const TabBarView(
          children: [
            NotificationList(),
            RequestList(),
            ConversationList(),
            RatingList(),
          ],
        ),
      ),
    );
  }
}
