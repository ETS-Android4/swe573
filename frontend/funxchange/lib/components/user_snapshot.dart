import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/user.dart';
import 'package:funxchange/screens/profile.dart';

class UserSnapshot extends StatefulWidget {
  final dz.Either<String, User> userFetcher;

  const UserSnapshot({Key? key, required this.userFetcher}) : super(key: key);

  @override
  State<UserSnapshot> createState() => _UserSnapshotState();
}

class _UserSnapshotState extends State<UserSnapshot> {
  User? _currentModel;

  @override
  Widget build(BuildContext context) {
    return widget.userFetcher.fold(
      (str) => FutureBuilder<User>(
        future: DIContainer.singleton.userRepo.fetchUser(str),
        builder: (ctx, ss) {
          if (!ss.hasData) {
            return const CupertinoActivityIndicator();
          }
          _currentModel = ss.requireData;
          return _actualWidget(ctx);
        },
      ),
      (user) {
        _currentModel = user;
        return _actualWidget(context);
      },
    );
  }

  Widget _actualWidget(BuildContext context) {
    var followed = _currentModel!.isFollowed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(Icons.person),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
            child: Text(_currentModel!.userName),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ProfilePage(userId: _currentModel!.id)));
            }),
        const SizedBox(
          width: 10,
        ),
        (followed != null)
            ? MaterialButton(
                height: 30,
                onPressed: () {
                  setState(() {
                    if (_currentModel != null) {
                      if (_currentModel!.isFollowed!) {
                        DIContainer.singleton.userRepo
                            .unfollowUser(_currentModel!.id);
                      } else {
                        DIContainer.singleton.userRepo
                            .followUser(_currentModel!.id);
                      }
                      _currentModel!.isFollowed = !_currentModel!.isFollowed!;
                    }
                  });
                },
                color: !followed ? FunColor.fulvous : Colors.grey,
                child: !followed
                    ? const Text(
                        'FOLLOW',
                      )
                    : const Text("UNFOLLOW"),
              )
            : Container(height: 30)
      ],
    );
  }
}
