import 'dart:convert';

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
  String? _authToken = null;
  String? _currentUserId = null;

  FunxchangeApiDataSource._internal();

  static final singleton = FunxchangeApiDataSource._internal();

  Function(String?)? onAuthStatusChanged;

  Future<void> addAuthToken(String token, String username) async {
    _authToken = token;
    _currentUserId = (await fetchUserByUserName(username)).id;
    onAuthStatusChanged?.call(token);
  }

  @override
  Future<JoinRequest> acceptJoinRequest(JoinRequest request) {
    final String path = "/events/" +
        request.eventId +
        "/requestors/" +
        request.userId +
        "/accept";

    return _jsonPostRequest(
        path, "", (p0) => "", (p0) => JoinRequest.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<Event> createEvent(NewEventParams params, String userId) {
    return _jsonPostRequest<NewEventParams, Event>(
        "/events", params, (p0) => p0.toJson(), (p0) => Event.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<JoinRequest> createJoinRequest(String eventId, String userId) {
    final String path = "/events/" + eventId + "/join";

    return _jsonPostRequest(
        path, "", (p0) => "", (p0) => JoinRequest.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<List<Message>> fetchConversations(int limit, int offset) {
    return _jsonGetRequest(_makePaginatedPath("/conversations", offset, limit),
        (p0) => parseList((p1) => Message.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<Event> fetchEvent(String id) {
    return _jsonGetRequest("/events/" + id, (p0) => Event.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<List<Event>> fetchEventsOfUser(int limit, int offset, String userId) {
    return _jsonGetRequest(
        _makePaginatedPath("/user/" + userId + "/events", offset, limit),
        (p0) => parseList((p1) => Event.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<Event>> fetchFeed(int limit, int offset, bool followed) {
    return _jsonGetRequest(_makePaginatedPath("/events/feed", offset, limit),
        (p0) => parseList((p1) => Event.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<User>> fetchFollowed(int limit, int offset, String userId) {
    return _jsonGetRequest(
        _makePaginatedPath("/user/" + userId + "/followees", offset, limit),
        (p0) => parseList((p1) => User.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<User>> fetchFollowers(int limit, int offset, String userId) {
    return _jsonGetRequest(
        _makePaginatedPath("/user/" + userId + "/followers", offset, limit),
        (p0) => parseList((p1) => User.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<JoinRequest>> fetchJoinRequests(int limit, int offset) {
    return _jsonGetRequest(_makePaginatedPath("/requests", offset, limit),
        (p0) => parseList((p1) => JoinRequest.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<Message>> fetchMessages(
      int limit, int offset, String conversationId) {
    return _jsonGetRequest(
        _makePaginatedPath(
          "/conversations/" + conversationId + "/messages",
          offset,
          limit,
        ),
        (p0) => parseList((p1) => Message.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<NotificationModel>> fetchNotifications(int limit, int offset) {
    return _jsonGetRequest(_makePaginatedPath("/notifications", offset, limit),
        (p0) => parseList((p1) => NotificationModel.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<List<User>> fetchParticipants(String eventId, int limit, int offset) {
    return _jsonGetRequest(
        _makePaginatedPath(
            "/events/" + eventId + "/participants", offset, limit),
        (p0) => parseList((p1) => User.fromMap(p1), p0),
        authentication: _authToken);
  }

  @override
  Future<User> fetchUser(String id) {
    return _jsonGetRequest("/user/" + id, (p0) => User.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<User> fetchUserByUserName(String userName) {
    return _jsonGetRequest("/user/" + userName, (p0) => User.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<String> followUser(String userId) {
    return _jsonPostRequest(
        "/user/${userId}/followers", "", (p0) => "", (p0) => p0,
        authentication: _authToken);
  }

  @override
  String getCurrentUserId() {
    return _currentUserId!;
  }

  @override
  Future<JoinRequest> rejectJoinRequest(JoinRequest request) {
    final String path = "/events/" +
        request.eventId +
        "/requestors/" +
        request.userId +
        "/reject";

    return _jsonPostRequest(
        path, "", (p0) => "", (p0) => JoinRequest.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<Message> sendMessage(String text, String receiverId) {
    return _jsonPostRequest(
        "/conversations",
        {"text": text, "receiverId": receiverId},
        (p0) => json.encode(p0),
        (p0) => Message.fromJson(p0),
        authentication: _authToken);
  }

  @override
  Future<String> unfollowUser(String userId) {
    return _jsonDeleteRequest("/user/$userId/followers", (p0) => p0,
        authentication: _authToken);
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

  List<T> parseList<T>(
      T Function(Map<String, dynamic>) deserializer, String source) {
    return List<T>.from(json.decode(source).map((i) => deserializer(i)));
  }

  String _makePaginatedPath(String base, int offset, int limit) {
    return base + "?limit=" + limit.toString() + "&offset=" + offset.toString();
  }

  Future<T> _jsonPostRequest<P, T>(
    String path,
    P body,
    String Function(P) serializer,
    T Function(String) deserializer, {
    String? authentication,
  }) async {
    print("POST " + path);
    final String urlStr = _baseUrl + path;
    final url = Uri.parse(urlStr);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (authentication != null) "Authorization": "Bearer " + authentication
      },
      body: serializer(body),
    );
    print("POST " + path + " " + response.statusCode.toString());
    if (response.statusCode == 401 || response.statusCode == 403) {
      _authToken = null;
      onAuthStatusChanged?.call(null);
    }
    return deserializer(response.body);
  }

  Future<T> _jsonGetRequest<P, T>(
    String path,
    T Function(String) deserializer, {
    String? authentication,
  }) async {
    print("GET " + path);
    final String urlStr = _baseUrl + path;
    final url = Uri.parse(urlStr);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (authentication != null) "Authorization": "Bearer " + authentication
      },
    );
    print("GET " + path + " " + response.statusCode.toString());
    if (response.statusCode == 401 || response.statusCode == 403) {
      _authToken = null;
      onAuthStatusChanged?.call(null);
    }
    return deserializer(response.body);
  }

  Future<T> _jsonDeleteRequest<P, T>(
    String path,
    T Function(String) deserializer, {
    String? authentication,
  }) async {
    print("DELETE " + path);
    final String urlStr = _baseUrl + path;
    final url = Uri.parse(urlStr);
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        if (authentication != null) "Authorization": "Bearer " + authentication
      },
    );
    print("DELETE " + path + " " + response.statusCode.toString());
    if (response.statusCode == 401 || response.statusCode == 403) {
      _authToken = null;
      onAuthStatusChanged?.call(null);
    }
    return deserializer(response.body);
  }
}
