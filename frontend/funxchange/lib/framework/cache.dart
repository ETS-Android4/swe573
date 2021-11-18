import 'dart:typed_data';

import 'package:funxchange/models/interest.dart';

class Cache {
  static Map<Interest, Uint8List> _interestImgCache = {};

  static Future<Map<Interest, Uint8List>> interestImageMap() =>
      Cache._interestImgCache.isNotEmpty
          ? Future.value(Cache._interestImgCache)
          : Future.wait(Interest.values.map(
              (e) => e.imageData.then(
                (value) => MapEntry(e, value),
              ),
            )).then((value) => Map.fromEntries(value)).then((value) {
              Cache._interestImgCache = value;
              return value;
            });
}
