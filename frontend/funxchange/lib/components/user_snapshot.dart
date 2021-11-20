import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
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
        var user = ss.requireData;
        var followed = user.isFollowed;
        return Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(
              width: 10,
            ),
            Text(user.userName),
            const SizedBox(
              width: 10,
            ),
            if (followed != null)
              MaterialButton(
                height: 30,
                onPressed: () {
                  print("follow user pressed");
                  // TODO: follow user
                },
                color: !followed ? FunColor.fulvous : Colors.grey,
                child: !followed
                    ? const Text(
                        'FOLLOW',
                      )
                    : const Text("UNFOLLOW"),
              )
          ],
        );
      },
    );
  }
}
