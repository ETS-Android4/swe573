import 'package:flutter/material.dart';
import 'package:funxchange/models/notification.dart';

class NotificationTile extends StatelessWidget {

  final NotificationModel model;

  const NotificationTile({ Key? key, required this.model }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(model.htmlText);
  }
}