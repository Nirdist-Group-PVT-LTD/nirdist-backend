import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'api_client.dart';

class SocketService {
  StompClient? _client;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  String _buildSocketUrl() {
    final base = ApiClient.baseUrl.replaceFirst('/api', '');
    return '$base/ws';
  }

  void connect({void Function()? onConnect, void Function(String)? onError}) {
    if (_client != null) {
      return;
    }

    final headers = <String, String>{};
    final token = ApiClient.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    _client = StompClient(
      config: StompConfig.sockJS(
        url: _buildSocketUrl(),
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        onConnect: (frame) {
          _isConnected = true;
          if (onConnect != null) {
            onConnect();
          }
        },
        onWebSocketError: (dynamic error) {
          _isConnected = false;
          if (onError != null) {
            onError(error.toString());
          }
        },
        onStompError: (frame) {
          _isConnected = false;
          if (onError != null) {
            onError(frame.body ?? 'STOMP error');
          }
        },
      ),
    );

    _client?.activate();
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
    _isConnected = false;
  }

  StompUnsubscribe? subscribe(String destination, void Function(StompFrame) callback) {
    if (_client == null) {
      return null;
    }
    return _client?.subscribe(destination: destination, callback: callback);
  }

  void send(String destination, Map<String, dynamic> body) {
    if (_client == null) {
      return;
    }
    _client?.send(destination: destination, body: jsonEncode(body));
  }
}
