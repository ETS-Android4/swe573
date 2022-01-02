import 'package:funxchange/data_source/rating.dart';
import 'package:funxchange/models/rating.dart';

class RatingRepository {
  final RatingDataSource dataSource;

  RatingRepository(this.dataSource);

  Future<List<Rating>> fetchRatings(int limit, int offset) {
    return dataSource.fetchRatings(limit, offset);
  }

  Future<Rating> updateRating(Rating rating) {
    return dataSource.updateRating(rating);
  }
}
