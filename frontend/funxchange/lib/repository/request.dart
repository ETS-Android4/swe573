import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/models/request.dart';

class JoinRequestRepository {
  final JoinRequestDataSource dataSource;

  JoinRequestRepository(this.dataSource);

  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset) {
    return dataSource.fetchJoinRequests(limit, offset);
  }
}
