import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/deeplink.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/request.dart';
import 'package:html/parser.dart';

class JoinRequestTile extends StatelessWidget {
  final JoinRequest model;
  final Function(JoinRequest) onAcceptTapped;
  final Function(JoinRequest) onRejectTapped;

  const JoinRequestTile({
    Key? key,
    required this.model,
    required this.onAcceptTapped,
    required this.onRejectTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final document = parse(model.htmlText);
    final span = Utils.parseSpans(document, null, (deeplink) {
      DeeplinkNavigator.of(context).navigate(deeplink);
    });
    return Padding(
      child: Column(
        children: [
          RichText(text: span),
          const SizedBox(height: 10),
          Row(
            children: [
              MaterialButton(
                onPressed: () {
                  onRejectTapped(model);
                },
                color: Colors.grey,
                child: const Text('REJECT'),
              ),
              MaterialButton(
                onPressed: () {
                  onAcceptTapped(model);
                },
                color: FunColor.fulvous,
                child: const Text('ACCEPT'),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
        ],
      ),
      padding: const EdgeInsets.all(12.0),
    );
  }
}
