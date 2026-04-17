import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_models.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final userId = auth.currentUser?.vId ?? 0;
      if (userId > 0) {
        context.read<ChatProvider>().loadRooms(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: _showCreateRoomDialog,
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.error != null) {
            return Center(child: Text(chatProvider.error!));
          }

          final rooms = chatProvider.rooms;
          if (rooms.isEmpty) {
            return Center(
              child: Text(
                'No chats yet',
                style: TextStyle(color: Colors.blueGrey.shade200),
              ),
            );
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                ),
                title: Text(room.name.isNotEmpty ? room.name : 'Chat ${room.roomId}'),
                subtitle: Text(room.isGroup ? 'Group chat' : 'Direct chat'),
                onTap: () => _openRoom(room),
              );
            },
          );
        },
      ),
    );
  }

  void _openRoom(ChatRoom room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(room: room),
      ),
    );
  }

  void _showCreateRoomDialog() {
    final auth = context.read<AuthProvider>();
    final userId = auth.currentUser?.vId ?? 0;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    final nameController = TextEditingController();
    final participantController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('New chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Room name (optional)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: participantController,
                decoration: const InputDecoration(labelText: 'Participant userId'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final otherId = int.tryParse(participantController.text.trim());
                if (otherId == null || otherId <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Enter a valid userId')),
                  );
                  return;
                }

                final chatProvider = context.read<ChatProvider>();
                final room = await chatProvider.createRoom(
                  createdBy: userId,
                  participantIds: [userId, otherId],
                  name: nameController.text.trim(),
                  isGroup: false,
                );

                if (room != null && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  _openRoom(room);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      participantController.dispose();
    });
  }
}
