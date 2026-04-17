import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../models/chat_models.dart';

class ApiClient {
  static const String baseUrl = 'https://nirdist-backend.onrender.com/api';  // Production Render
  // static const String baseUrl = 'http://localhost:8080/api';  // Local testing
  // static const String baseUrl = 'https://api.nirdist.com/api';  // Cloudflare CNAME (fix .np issue first)
  // For Android device/emulator, use: 'http://10.0.2.2:8080/api'
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static String? _token;
  static Map<String, dynamic>? _cachedUser;

  /// Initialize token and user from persistent storage
  static Future<void> initializeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        _cachedUser = jsonDecode(userJson);
      }
    } catch (e) {
      print('Error loading token/user from storage: $e');
    }
  }

  /// Save token and user to persistent storage
  static Future<void> setToken(String token, [Map<String, dynamic>? user]) async {
    _token = token;
    if (user != null) {
      _cachedUser = user;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      if (user != null) {
        await prefs.setString(_userKey, jsonEncode(user));
      }
    } catch (e) {
      print('Error saving token/user to storage: $e');
    }
  }

  /// Clear token and user from memory and storage
  static Future<void> clearToken() async {
    _token = null;
    _cachedUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error clearing token from storage: $e');
    }
  }

  /// Get current token
  static String? getToken() => _token;

  /// Get cached user data
  static Map<String, dynamic>? getCachedUser() => _cachedUser;

  static Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Map<String, dynamic> _parseObjectResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return decoded;
    }
    throw Exception('Invalid response format');
  }

  static List<dynamic> _parseListResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        return data;
      }
    }
    if (decoded is List) {
      return decoded;
    }
    throw Exception('Invalid response format');
  }

  // Auth
  static Future<Map<String, dynamic>> register({
    required String vName,
    required String vUsername,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(),
        body: jsonEncode({
          'vName': vName,
          'vUsername': vUsername,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Persist token and user data
        await setToken(data['token'], data['user'] ?? data);
        return data;
      } else {
        if (response.body.isEmpty) {
          throw Exception('Registration failed: empty response from server');
        }
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Registration failed');
        } catch (e) {
          throw Exception('Registration failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> login({
    required String vUsername,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'vUsername': vUsername,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Persist token and user data
        await setToken(data['token'], data['user'] ?? data);
        return data;
      } else {
        if (response.body.isEmpty) {
          throw Exception('Login failed: empty response from server');
        }
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Login failed');
        } catch (e) {
          throw Exception('Login failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Instance methods for non-static context
  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String bio = '',
    String profilePicture = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(),
        body: jsonEncode({
          'vUsername': username,
          'vName': fullName,
          'email': email,
          'password': password,
          'bio': bio,
          'profilePicture': profilePicture,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final userPayload = (data['user'] as Map<String, dynamic>?) ?? {};
        return {
          'success': true,
          'token': data['token'],
          'user': userPayload,
        };
      } else {
        if (response.body.isEmpty) {
          return {
            'success': false,
            'message': 'Registration failed: empty response from server'
          };
        }
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Registration failed'
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Registration failed: ${response.statusCode}'
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final userPayload = (data['user'] as Map<String, dynamic>?) ?? {};
        return {
          'success': true,
          'token': data['token'],
          'user': userPayload,
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }

  // Users
  static Future<User> getProfile(int vId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$vId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<User>> searchUsers(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/search?q=$query'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((u) => User.fromJson(u)).toList();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Posts
  static Future<List<Post>> getFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/feed?page=$page&limit=$limit'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((p) => Post.fromJson(p)).toList();
      } else {
        throw Exception('Failed to fetch feed');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Post> getPost(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$pId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return Post.fromJson(data);
      } else {
        throw Exception('Failed to fetch post');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Post>> getUserPosts(int vId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/user/$vId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((p) => Post.fromJson(p)).toList();
      } else {
        throw Exception('Failed to fetch user posts');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deletePost(int pId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$pId'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Post> createPost({
    required int vId,
    required String vName,
    required String vUsername,
    required String description,
    List<String> media = const [],
  }) async {
    try {
      final payload = {
        'vId': vId,
        'vName': vName,
        'vUsername': vUsername,
        'discription': description,
        'media': media.isEmpty ? null : jsonEncode(media),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: _getHeaders(),
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return Post.fromJson(data);
      }

      throw Exception('Failed to create post');
    } catch (e) {
      rethrow;
    }
  }

  // Stories
  static Future<List<Story>> getStories({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories?page=$page&limit=$limit'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((s) => Story.fromJson(s)).toList();
      } else {
        throw Exception('Failed to fetch stories');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Story> createStory({
    required int vId,
    required String vName,
    required String vUsername,
    required String mediaUrl,
    String caption = '',
  }) async {
    try {
      final payload = {
        'vId': vId,
        'vName': vName,
        'vUsername': vUsername,
        'media': mediaUrl,
        'caption': caption,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/stories'),
        headers: _getHeaders(),
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return Story.fromJson(data);
      }

      throw Exception('Failed to create story');
    } catch (e) {
      rethrow;
    }
  }

  // Notes
  static Future<List<Note>> getNotes({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notes?page=$page&limit=$limit'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((n) => Note.fromJson(n)).toList();
      } else {
        throw Exception('Failed to fetch notes');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sounds
  static Future<List<Sound>> getAllSounds({int page = 1, String query = ''}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sounds?page=$page&q=$query'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((s) => Sound.fromJson(s)).toList();
      } else {
        throw Exception('Failed to fetch sounds');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Comments
  static Future<List<Comment>> getComments(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comments/post/$pId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((c) => Comment.fromJson(c)).toList();
      } else {
        throw Exception('Failed to fetch comments');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Follows
  static Future<void> followUser(int followeeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/follows/$followeeId/follow'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to follow user');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> unfollowUser(int followeeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/follows/$followeeId/unfollow'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unfollow user');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Chat
  static Future<List<ChatRoom>> getChatRooms(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat/rooms?userId=$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((item) => ChatRoom.fromJson(item)).toList();
      }
      throw Exception('Failed to load chat rooms');
    } catch (e) {
      rethrow;
    }
  }

  static Future<ChatRoom> createChatRoom({
    required int createdBy,
    required List<int> participantIds,
    String? name,
    bool isGroup = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/rooms'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'isGroup': isGroup,
          'createdBy': createdBy,
          'participantIds': participantIds,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return ChatRoom.fromJson(data);
      }
      throw Exception('Failed to create chat room');
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ChatMessage>> getChatMessages(int roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat/rooms/$roomId/messages'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = _parseListResponse(response.body);
        return data.map((item) => ChatMessage.fromJson(item)).toList();
      }
      throw Exception('Failed to load messages');
    } catch (e) {
      rethrow;
    }
  }

  static Future<ChatMessage> sendChatMessage({
    required int roomId,
    required int senderId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/rooms/$roomId/messages'),
        headers: _getHeaders(),
        body: jsonEncode({
          'senderId': senderId,
          'content': content,
          'messageType': 'TEXT',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return ChatMessage.fromJson(data);
      }
      throw Exception('Failed to send message');
    } catch (e) {
      rethrow;
    }
  }

  // Calls
  static Future<CallSession> createCallSession({required int createdBy}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calls/sessions'),
        headers: _getHeaders(),
        body: jsonEncode({
          'createdBy': createdBy,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _parseObjectResponse(response.body);
        return CallSession.fromJson(data);
      }
      throw Exception('Failed to create call');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> joinCallSession({required int sessionId, required int userId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calls/sessions/$sessionId/join'),
        headers: _getHeaders(),
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to join call');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> leaveCallSession({required int sessionId, required int userId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calls/sessions/$sessionId/leave'),
        headers: _getHeaders(),
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to leave call');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> endCallSession({required int sessionId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calls/sessions/$sessionId/end'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to end call');
      }
    } catch (e) {
      rethrow;
    }
  }
}
