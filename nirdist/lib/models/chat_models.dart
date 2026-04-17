class ChatRoom {
  final int roomId;
  final String name;
  final bool isGroup;
  final int createdBy;
  final DateTime? createdAt;
  final List<int> participantIds;

  ChatRoom({
    required this.roomId,
    required this.name,
    required this.isGroup,
    required this.createdBy,
    required this.participantIds,
    this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'] ?? json['room_id'] ?? 0,
      name: json['name'] ?? '',
      isGroup: json['isGroup'] ?? json['is_group'] ?? false,
      createdBy: json['createdBy'] ?? json['created_by'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null),
      participantIds: List<int>.from(json['participantIds'] ?? json['participant_ids'] ?? []),
    );
  }
}

class ChatMessage {
  final int messageId;
  final int roomId;
  final int senderId;
  final String content;
  final String messageType;
  final DateTime? createdAt;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId'] ?? json['message_id'] ?? 0,
      roomId: json['roomId'] ?? json['room_id'] ?? 0,
      senderId: json['senderId'] ?? json['sender_id'] ?? 0,
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? json['message_type'] ?? 'TEXT',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null),
    );
  }
}

class CallSession {
  final int sessionId;
  final String roomId;
  final int createdBy;
  final String status;
  final DateTime? createdAt;
  final DateTime? endedAt;
  final List<int> participantIds;

  CallSession({
    required this.sessionId,
    required this.roomId,
    required this.createdBy,
    required this.status,
    required this.participantIds,
    this.createdAt,
    this.endedAt,
  });

  factory CallSession.fromJson(Map<String, dynamic> json) {
    return CallSession(
      sessionId: json['sessionId'] ?? json['session_id'] ?? 0,
      roomId: json['roomId'] ?? json['room_id'] ?? '',
      createdBy: json['createdBy'] ?? json['created_by'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null),
      endedAt: json['endedAt'] != null
          ? DateTime.tryParse(json['endedAt'])
          : (json['ended_at'] != null ? DateTime.tryParse(json['ended_at']) : null),
      participantIds: List<int>.from(json['participantIds'] ?? json['participant_ids'] ?? []),
    );
  }
}
