import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/models/request.dart';

class MockJoinRequestDataSource implements JoinRequestDataSource {

  static List<JoinRequest> data = [];

  @override
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset) {
    return MockUtils.delayed(() => data.skip(offset).take(limit).toList());
  }

}