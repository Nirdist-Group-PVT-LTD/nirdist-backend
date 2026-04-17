import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../models/chat_models.dart';
import '../providers/call_provider.dart';

class CallScreen extends StatefulWidget {
  final CallSession session;
  final int userId;
  final bool isCaller;

  const CallScreen({
    Key? key,
    required this.session,
    required this.userId,
    required this.isCaller,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CallProvider>().joinCall(
            sessionId: widget.session.sessionId,
            userId: widget.userId,
            isCaller: widget.isCaller,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final callProvider = context.watch<CallProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RTCVideoView(
              callProvider.remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RTCVideoView(
                callProvider.localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'end',
                  backgroundColor: Colors.redAccent,
                  onPressed: () async {
                    await callProvider.endCall(sessionId: widget.session.sessionId);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
