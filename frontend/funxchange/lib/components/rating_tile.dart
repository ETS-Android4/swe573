import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/rating.dart';

class RatingTile extends StatefulWidget {
  final Rating model;
  const RatingTile({Key? key, required this.model}) : super(key: key);

  @override
  State<RatingTile> createState() => _RatingTileState();
}

class _RatingTileState extends State<RatingTile> {
  late Rating _model;

  bool isRateable() {
    return _model.rating == null;
  }

  @override
  void initState() {
    _model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ratingBar = RatingBar.builder(
      initialRating: _model.rating?.toDouble() ?? 0.0,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        final intRating = rating.toInt();
        if (intRating > 0) {
          setState(() {
            _model.rating = intRating;
            DIContainer.singleton.ratingRepo.updateRating(_model);
          });
        }
      },
    );

    final rateable = isRateable();
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: FunColor.fulvous,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          if (rateable) Text("Please rate:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_model.user.userName + " in " + _model.event.title),
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rateable)
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _model.rating = 0;
                      DIContainer.singleton.ratingRepo.updateRating(_model);
                    });
                  },
                  color: Colors.grey,
                  child: const Text('NO SHOW'),
                ),
              (rateable)
                  ? ratingBar
                  : IgnorePointer(
                      child: ratingBar,
                    ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
