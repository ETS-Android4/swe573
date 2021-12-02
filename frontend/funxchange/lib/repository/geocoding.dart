import 'package:funxchange/data_source/geocoding.dart';
import 'package:funxchange/models/location.dart';

class GeocodingRepository {
  final GeocodingDataSource dataSource;

  GeocodingRepository(this.dataSource);

  Future<Location> reverseGeocode(double latitude, double longitude) {
    return dataSource.reverseGeocode(latitude, longitude);
  }
}