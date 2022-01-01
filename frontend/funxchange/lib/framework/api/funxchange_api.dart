import 'package:funxchange/data_source/auth.dart';
import 'package:funxchange/data_source/event.dart';
import 'package:funxchange/data_source/message.dart';
import 'package:funxchange/data_source/notification.dart';
import 'package:funxchange/data_source/request.dart';
import 'package:funxchange/data_source/user.dart';
import 'package:funxchange/models/new_user.dart';
import 'package:funxchange/models/auth_response.dart';
import 'package:funxchange/models/auth_params.dart';
import 'package:funxchange/models/user.dart';
import 'package:funxchange/models/request.dart';
import 'package:funxchange/models/notification.dart';
import 'package:funxchange/models/new_event.dart';
import 'package:funxchange/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:funxchange/models/event.dart';

class FunxchangeApiDataSource
    implements
        EventDataSource,
        MessageDataSource,
        NotificationDataSource,
        JoinRequestDataSource,
        UserDataSource,
        AuthDataSource {
  static const String _baseUrl = "http://20.107.24.75:8080";
  String? authToken = null;

  @override
  Future<JoinRequest> acceptJoinRequest(JoinRequest request) {
    // TODO: implement acceptJoinRequest
    throw UnimplementedError();
  }

  @override
  Future<Event> createEvent(NewEventParams params, String userId) {
    // TODO: implement createEvent
    throw UnimplementedError();
  }

  @override
  Future<JoinRequest> createJoinRequest(String eventId, String userId) {
    // TODO: implement createJoinRequest
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> fetchConversations(int limit, int offset) {
    // TODO: implement fetchConversations
    throw UnimplementedError();
  }

  @override
  Future<Event> fetchEvent(String id) {
    // TODO: implement fetchEvent
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> fetchEventsOfUser(int limit, int offset, String userId) {
    // TODO: implement fetchEventsOfUser
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> fetchFeed(int limit, int offset, bool followed) {
    // TODO: implement fetchFeed
    throw UnimplementedError();
  }

  @override
  Future<List<User>> fetchFollowed(int limit, int offset, String userId) {
    // TODO: implement fetchFollowed
    throw UnimplementedError();
  }

  @override
  Future<List<User>> fetchFollowers(int limit, int offset, String userId) {
    // TODO: implement fetchFollowers
    throw UnimplementedError();
  }

  @override
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset) {
    // TODO: implement fetchJoinRequests
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> fetchMessages(
      int limit, int offset, String conversationId) {
    // TODO: implement fetchMessages
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationModel>> fetchNotifications(int limit, int offset) {
    // TODO: implement fetchNotifications
    throw UnimplementedError();
  }

  @override
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset) {
    // TODO: implement fetchParticipants
    throw UnimplementedError();
  }

  @override
  Future<User> fetchUser(String id) {
    // TODO: implement fetchUser
    throw UnimplementedError();
  }

  @override
  Future<User> fetchUserByUserName(String userName) {
    return _jsonGetRequest("/user/" + userName, (p0) => User.fromJson(p0),
        authentication: authToken);
  }

  @override
  Future<String> followUser(String userId) {
    // TODO: implement followUser
    throw UnimplementedError();
  }

  @override
  String getCurrentUserId() {
    // TODO: implement getCurrentUserId
    throw UnimplementedError();
  }

  @override
  Future<JoinRequest> rejectJoinRequest(JoinRequest request) {
    // TODO: implement rejectJoinRequest
    throw UnimplementedError();
  }

  @override
  Future<Message> sendMessage(String text, String receiverId) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<String> unfollowUser(String userId) {
    // TODO: implement unfollowUser
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> authenticate(AuthParams params) {
    return _jsonPostRequest<AuthParams, AuthResponse>(
      "/authenticate",
      params,
      (p0) => p0.toJson(),
      (p0) => AuthResponse.fromJson(p0),
    );
  }

  @override
  Future<AuthResponse> signUp(NewUserParams params) async {
    return _jsonPostRequest<NewUserParams, AuthResponse>(
      "/signup",
      params,
      (p0) => p0.toJson(),
      (p0) => AuthResponse.fromJson(p0),
    );
  }

  Future<T> _jsonPostRequest<P, T>(
    String path,
    P body,
    String Function(P) serializer,
    T Function(String) deserializer,
  ) async {
    final String urlStr = _baseUrl + path;
    final url = Uri.parse(urlStr);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: serializer(body),
    );
    if (response.statusCode == 401) {
      authToken = null;
    }
    return deserializer(response.body);
  }

  Future<T> _jsonGetRequest<P, T>(
    String path,
    T Function(String) deserializer, {
    String? authentication,
  }) async {
    final String urlStr = _baseUrl + path;
    final url = Uri.parse(urlStr);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (authentication != null) "Authorization": "Bearer " + authentication
      },
    );
    if (response.statusCode == 401) {
      authToken = null;
    }
    return deserializer(response.body);
  }
}
