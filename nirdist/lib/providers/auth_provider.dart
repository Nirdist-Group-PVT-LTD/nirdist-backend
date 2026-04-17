import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _restoreSession();
  }

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _token != null;

  Future<void> _restoreSession() async {
    final token = ApiClient.getToken();
    final cachedUser = ApiClient.getCachedUser();

    if (token == null || token.isEmpty) {
      return;
    }

    _token = token;
    if (cachedUser != null) {
      _currentUser = _buildUserFromPayload(cachedUser);
    }
    notifyListeners();
  }

  User _buildUserFromPayload(Map<String, dynamic> payload) {
    return User(
      vId: payload['v_id'] ?? payload['vId'] ?? payload['id'] ?? 0,
      vName: payload['v_name'] ?? payload['fullName'] ?? payload['vName'] ?? '',
      vUsername:
          payload['v_username'] ?? payload['username'] ?? payload['vUsername'] ?? '',
      email: payload['email'] ?? '',
      bio: payload['bio'] ?? '',
      profilePicture: payload['profilePicture'] ?? payload['profile_picture'] ?? '',
      followerCount: payload['followerCount'] ?? 0,
      followingCount: payload['followingCount'] ?? 0,
      postCount: payload['postCount'] ?? 0,
    );
  }

  Future<void> _persistSession(String token, Map<String, dynamic> userPayload) async {
    await ApiClient.setToken(token, userPayload);
    _token = token;
    _currentUser = _buildUserFromPayload(userPayload);
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.signup(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        bio: '',
        profilePicture: '',
      );

      if (response['success'] == true) {
        final userPayload = (response['user'] as Map<String, dynamic>?) ?? {};
        await _persistSession(response['token'], userPayload);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Signup failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.loginWithEmail(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        final userPayload = (response['user'] as Map<String, dynamic>?) ?? {};
        await _persistSession(response['token'], userPayload);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _token = null;
    _errorMessage = null;
    ApiClient.clearToken();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
