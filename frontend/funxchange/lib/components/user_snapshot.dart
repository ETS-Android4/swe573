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
  void initState() {
    widget.userFetcher.fold(
      (str) => DIContainer.singleton.userRepo.fetchUser(str).then((value) {
        setState(() {
          _currentModel = value;
        });
      }),
      (r) {
        _currentModel = r;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _currentModel;
    if (user != null) {
      return _actualWidget(context, user);
    } else {
      return const CupertinoActivityIndicator();
    }
  }

  Widget _actualWidget(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
                child: Text(user.userName),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ProfilePage(userId: user.id)));
                }),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              const Icon(Icons.star),
              Text(user.ratingAvg.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          (user.isFollowed != null)
              ? GestureDetector(
                  child: const Icon(Icons.message),
                  onTap: () {
                    showSendMessageDialog(user);
                  },
                )
              : Container(height: 30),
          const SizedBox(
            width: 10,
          ),
          (user.isFollowed != null)
              ? MaterialButton(
                  height: 30,
                  onPressed: () {
                    setState(() {
                      if (user.isFollowed!) {
                        DIContainer.activeSingleton.userRepo
                            .unfollowUser(user.id);
                      } else {
                        DIContainer.activeSingleton.userRepo
                            .followUser(user.id);
                      }
                      user.isFollowed = !user.isFollowed!;
                    });
                  },
                  color: !user.isFollowed! ? FunColor.fulvous : Colors.grey,
                  child: !user.isFollowed!
                      ? const Text(
                          'FOLLOW',
                        )
                      : const Text("UNFOLLOW"),
                )
              : Container(height: 30)
        ],
      ),
    );
  }

  void showSendMessageDialog(User user) {
    showDialog(
      context: context,
      builder: (_) {
        var messageController = TextEditingController();
        var isSending = false;
        return AlertDialog(
          title: const Text('Send A Message'),
          content: TextFormField(
            controller: messageController,
            decoration: const InputDecoration(hintText: 'Message'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                var text = messageController.text;

                if (text.isEmpty || isSending) return;

                isSending = true;

                DIContainer.activeSingleton.messageRepo
                    .sendMessage(text, user.id);

                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
