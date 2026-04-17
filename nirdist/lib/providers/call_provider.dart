import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../models/chat_models.dart';
import '../services/api_client.dart';
import '../services/socket_service.dart';

class CallProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  StompUnsubscribe? _subscription;
  bool _isInCall = false;
  String? _error;

  bool get isInCall => _isInCall;
  String? get error => _error;

  Future<CallSession> createSession({required int createdBy}) async {
    return ApiClient.createCallSession(createdBy: createdBy);
  }

  Future<void> joinCall({
    required int sessionId,
    required int userId,
    required bool isCaller,
  }) async {
    _error = null;
    try {
      await ApiClient.joinCallSession(sessionId: sessionId, userId: userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _socketService.connect();
    _subscription = _socketService.subscribe(
      '/topic/calls/$sessionId',
      (StompFrame frame) async {
        if (frame.body == null) {
          return;
        }

        final payload = jsonDecode(frame.body!);
        if (payload is! Map<String, dynamic>) {
          return;
        }

        final type = payload['type'] as String? ?? '';
        if (payload['senderId'] == userId) {
          return;
        }

        if (type == 'offer') {
          await _handleOffer(sessionId, payload);
        } else if (type == 'answer') {
          await _handleAnswer(payload);
        } else if (type == 'ice') {
          await _handleIce(payload);
        }
      },
    );

    await _preparePeerConnection(sessionId, userId);

    if (isCaller) {
      await _createAndSendOffer(sessionId, userId);
    }

    _isInCall = true;
    notifyListeners();
  }

  Future<void> leaveCall({required int sessionId, required int userId}) async {
    await ApiClient.leaveCallSession(sessionId: sessionId, userId: userId);
    await _cleanup();
  }

  Future<void> endCall({required int sessionId}) async {
    await ApiClient.endCallSession(sessionId: sessionId);
    await _cleanup();
  }

  Future<void> _preparePeerConnection(int sessionId, int userId) async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate == null) {
        return;
      }
      _socketService.send(
        '/app/calls/$sessionId/signal',
        {
          'senderId': userId,
          'type': 'ice',
          'payload': jsonEncode(candidate.toMap()),
        },
      );
    };

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
        notifyListeners();
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });
    localRenderer.srcObject = _localStream;

    for (final track in _localStream!.getTracks()) {
      await _peerConnection?.addTrack(track, _localStream!);
    }
  }

  Future<void> _createAndSendOffer(int sessionId, int userId) async {
    final offer = await _peerConnection?.createOffer();
    if (offer == null) {
      return;
    }
    await _peerConnection?.setLocalDescription(offer);
    _socketService.send(
      '/app/calls/$sessionId/signal',
      {
        'senderId': userId,
        'type': 'offer',
        'payload': jsonEncode(offer.toMap()),
      },
    );
  }

  Future<void> _handleOffer(int sessionId, Map<String, dynamic> payload) async {
    final offerMap = jsonDecode(payload['payload'] ?? '{}');
    final offer = RTCSessionDescription(offerMap['sdp'], offerMap['type']);
    await _peerConnection?.setRemoteDescription(offer);

    final answer = await _peerConnection?.createAnswer();
    if (answer == null) {
      return;
    }
    await _peerConnection?.setLocalDescription(answer);

    _socketService.send(
      '/app/calls/$sessionId/signal',
      {
        'senderId': payload['senderId'],
        'type': 'answer',
        'payload': jsonEncode(answer.toMap()),
      },
    );
  }

  Future<void> _handleAnswer(Map<String, dynamic> payload) async {
    final answerMap = jsonDecode(payload['payload'] ?? '{}');
    final answer = RTCSessionDescription(answerMap['sdp'], answerMap['type']);
    await _peerConnection?.setRemoteDescription(answer);
  }

  Future<void> _handleIce(Map<String, dynamic> payload) async {
    final candidateMap = jsonDecode(payload['payload'] ?? '{}');
    final candidate = RTCIceCandidate(
      candidateMap['candidate'],
      candidateMap['sdpMid'],
      candidateMap['sdpMLineIndex'],
    );
    await _peerConnection?.addCandidate(candidate);
  }

  Future<void> _cleanup() async {
    await _localStream?.dispose();
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    await _peerConnection?.close();
    _peerConnection = null;
    _subscription?.call();
    _subscription = null;
    _socketService.disconnect();
    _isInCall = false;
    notifyListeners();
  }
}
