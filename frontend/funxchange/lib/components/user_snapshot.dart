import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/user.dart';

class UserSnapshot extends StatelessWidget {
  final Either<String, User> userFetcher;

  const UserSnapshot({Key? key, required this.userFetcher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userFetcher.fold(
      (str) => FutureBuilder<User>(
        future: DIContainer.singleton.userRepo.fetchUser(str),
        builder: (ctx, ss) {
          if (!ss.hasData) {
            return const CupertinoActivityIndicator();
          }
          var user = ss.requireData;
          return _actualWidget(user);
        },
      ),
      (user) => _actualWidget(user),
    );
  }

  Widget _actualWidget(User user) {
    var followed = user.isFollowed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
  }
}
