import 'package:funxchange/models/rating.dart';

abstract class RatingDataSource {
  Future<List<Rating>> fetchRatings(int limit, int offset);
  Future<Rating> updateRating(Rating rating);
}