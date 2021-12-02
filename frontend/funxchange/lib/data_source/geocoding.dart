import 'package:funxchange/models/location.dart';

abstract class GeocodingDataSource {
  Future<Location> reverseGeocode(double latitude, double longitude);
}