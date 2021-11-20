import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/user.dart';

class UserSnapshot extends StatelessWidget {
  final String userId;

  const UserSnapshot({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: DIContainer.singleton.userRepo.fetchUser(userId),
      builder: (ctx, ss) {
        if (!ss.hasData) {
          return const CupertinoActivityIndicator();
        }
        return Text(ss.requireData.userName);
      },
    );
  }
}
