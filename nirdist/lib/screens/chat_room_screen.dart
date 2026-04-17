import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_models.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/call_provider.dart';
import 'call_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.loadMessages(widget.room.roomId);
      chatProvider.subscribeToRoom(widget.room.roomId);
    });
  }

  @override
  void dispose() {
    context.read<ChatProvider>().disposeRoomSubscription(widget.room.roomId);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.vId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name.isNotEmpty ? widget.room.name : 'Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: userId == 0 ? null : () => _startCall(userId),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.messagesForRoom(widget.room.roomId);
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.blueGrey.shade200),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message.senderId == userId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primary
                              : Colors.blueGrey.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildComposer(userId),
        ],
      ),
    );
  }

  Widget _buildComposer(int userId) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  filled: true,
                  fillColor: Colors.blueGrey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
              onPressed: userId == 0 ? null : () => _sendMessage(userId),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(int userId) {
    final content = _messageController.text.trim();
    if (content.isEmpty) {
      return;
    }
    context.read<ChatProvider>().sendMessage(
          roomId: widget.room.roomId,
          senderId: userId,
          content: content,
        );
    _messageController.clear();
  }

  Future<void> _startCall(int userId) async {
    final callProvider = context.read<CallProvider>();
    final session = await callProvider.createSession(createdBy: userId);
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CallScreen(session: session, userId: userId, isCaller: true),
      ),
    );
  }
}
