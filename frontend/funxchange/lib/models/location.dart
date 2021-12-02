import 'dart:convert';

class Location {
  final String region;
  final String country;

  Location(this.region, this.country);

  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'country': country,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      map['region'],
      map['country'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));
}
