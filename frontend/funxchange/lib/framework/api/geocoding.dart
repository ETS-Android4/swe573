import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:funxchange/data_source/geocoding.dart';
import 'package:funxchange/models/location.dart';

class GeocodingApiDataSource implements GeocodingDataSource {
  static const String _accessKey = "a6ac1b34738bd3453c0813aad937b668";

  @override
  Future<Location> reverseGeocode(double latitude, double longitude) async {
    final urlStr =
        "http://api.positionstack.com/v1/reverse?access_key=$_accessKey&query=$latitude,$longitude";
    final url = Uri.parse(urlStr);
    final response = await http.get(url);
    return _Response.fromJson(response.body).data.first;
  }
}

class _Response {
  final List<Location> data;

  _Response(this.data);

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory _Response.fromMap(Map<String, dynamic> map) {
    return _Response(
      List<Location>.from(map['data']?.map((x) => Location.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory _Response.fromJson(String source) =>
      _Response.fromMap(json.decode(source));
}
