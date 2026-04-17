import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../models/chat_models.dart';
import '../services/api_client.dart';
import '../services/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  final Map<int, StompUnsubscribe?> _subscriptions = {};

  List<ChatRoom> _rooms = [];
  final Map<int, List<ChatMessage>> _messages = {};
  bool _isLoading = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ChatMessage> messagesForRoom(int roomId) {
    return _messages[roomId] ?? [];
  }

  void connectSocket() {
    _socketService.connect(onError: (err) {
      _error = err;
      notifyListeners();
    });
  }

  Future<void> loadRooms(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rooms = await ApiClient.getChatRooms(userId);
      _rooms = rooms;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(int roomId) async {
    try {
      final messages = await ApiClient.getChatMessages(roomId);
      _messages[roomId] = messages;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<ChatRoom?> createRoom({
    required int createdBy,
    required List<int> participantIds,
    String? name,
    bool isGroup = false,
  }) async {
    try {
      final room = await ApiClient.createChatRoom(
        createdBy: createdBy,
        participantIds: participantIds,
        name: name,
        isGroup: isGroup,
      );
      _rooms.insert(0, room);
      notifyListeners();
      return room;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> sendMessage({
    required int roomId,
    required int senderId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return;
    }

    if (_socketService.isConnected) {
      _socketService.send(
        '/app/rooms/$roomId/send',
        {
          'senderId': senderId,
          'content': content,
          'messageType': 'TEXT',
        },
      );
      return;
    }

    try {
      final message = await ApiClient.sendChatMessage(
        roomId: roomId,
        senderId: senderId,
        content: content,
      );
      _messages.putIfAbsent(roomId, () => []).add(message);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void subscribeToRoom(int roomId) {
    if (_subscriptions.containsKey(roomId)) {
      return;
    }

    connectSocket();

    _subscriptions[roomId] = _socketService.subscribe(
      '/topic/rooms/$roomId',
      (StompFrame frame) {
        if (frame.body == null) {
          return;
        }
        final payload = jsonDecode(frame.body!);
        if (payload is Map<String, dynamic>) {
          final message = ChatMessage.fromJson(payload);
          _messages.putIfAbsent(roomId, () => []).add(message);
          notifyListeners();
        }
      },
    );
  }

  void disposeRoomSubscription(int roomId) {
    _subscriptions[roomId]?.call();
    _subscriptions.remove(roomId);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription?.call();
    }
    _subscriptions.clear();
    _socketService.disconnect();
    super.dispose();
  }
}
