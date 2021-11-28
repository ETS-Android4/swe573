import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/request.dart';
import 'package:html/parser.dart';

class JoinRequestTile extends StatelessWidget {
  final JoinRequest model;

  const JoinRequestTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final document = parse(model.htmlText);
    final span = Utils.parseSpans(document, null);
    return Padding(
      child: Column(
        children: [
          RichText(text: span),
          const SizedBox(height: 10),
          Row(
            children: [
              MaterialButton(
                onPressed: () {
                  // TODO: implement
                  print("Reject request");
                },
                color: Colors.grey,
                child: const Text('REJECT'),
              ),
              MaterialButton(
                onPressed: () {
                  // TODO: implement
                  print("Accept request");
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
