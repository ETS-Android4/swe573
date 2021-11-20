import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/models/user.dart';

class UserSnapshot extends StatelessWidget {
  final Future<User> userFuture;

  const UserSnapshot({Key? key, required this.userFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userFuture,
      builder: (ctx, ss) {
        if (!ss.hasData) {
          return const CupertinoActivityIndicator();
        }
        return Text(ss.requireData.userName);
      },
    );
  }
}
