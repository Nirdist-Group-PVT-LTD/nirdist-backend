import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_client.dart';
import '../models/models.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFeed({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPosts = await ApiClient.getFeed(page: page, limit: limit);
      if (page == 1) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(int pId) async {
    try {
      await ApiClient.deletePost(pId);
      _posts.removeWhere((p) => p.pId == pId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  Map<int, User> _userCache = {};
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile(int vId) async {
    if (_userCache.containsKey(vId)) {
      _currentUser = _userCache[vId];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await ApiClient.getProfile(vId);
      _currentUser = user;
      _userCache[vId] = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      return await ApiClient.searchUsers(query);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<void> followUser(int followeeId) async {
    try {
      await ApiClient.followUser(followeeId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> unfollowUser(int followeeId) async {
    try {
      await ApiClient.unfollowUser(followeeId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

class StoryProvider extends ChangeNotifier {
  List<Story> _stories = [];
  bool _isLoading = false;
  String? _error;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStories({int page = 1, int limit = 20}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newStories = await ApiClient.getStories(page: page, limit: limit);
      if (page == 1) {
        _stories = newStories;
      } else {
        _stories.addAll(newStories);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
