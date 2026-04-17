import 'dart:convert';

class User {
  int vId;
  String vName;
  String vUsername;
  String email;
  String bio;
  String profilePicture;
  DateTime? vBirth;
  List<String> emails;
  List<String> phones;
  List<String> usernames;
  int followerCount;
  int followingCount;
  int postCount;

  User({
    required this.vId,
    required this.vName,
    required this.vUsername,
    this.email = '',
    this.bio = '',
    this.profilePicture = '',
    this.vBirth,
    this.emails = const [],
    this.phones = const [],
    this.usernames = const [],
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      vId: json['v_id'] ?? json['vId'] ?? 0,
      vName: json['v_name'] ?? json['vName'] ?? '',
      vUsername: json['v_username'] ?? json['vUsername'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profilePicture'] ?? json['profile_picture'] ?? '',
      vBirth: json['v_birth'] != null
          ? DateTime.parse(json['v_birth'])
          : (json['vBirth'] != null ? DateTime.parse(json['vBirth']) : null),
      emails: List<String>.from(json['emails'] ?? []),
      phones: List<String>.from(json['phones'] ?? []),
      usernames: List<String>.from(json['usernames'] ?? []),
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postCount: json['postCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'v_id': vId,
    'v_name': vName,
    'v_username': vUsername,
    'email': email,
    'bio': bio,
    'profilePicture': profilePicture,
    'v_birth': vBirth?.toIso8601String(),
    'emails': emails,
    'phones': phones,
    'usernames': usernames,
    'followerCount': followerCount,
    'followingCount': followingCount,
    'postCount': postCount,
  };
}

List<String> _parseMediaList(dynamic mediaField) {
  if (mediaField == null) {
    return [];
  }

  if (mediaField is List) {
    return mediaField.map((item) {
      if (item is String) {
        return item;
      }
      if (item is Map && item['p_m_link'] != null) {
        return item['p_m_link'].toString();
      }
      return item.toString();
    }).toList();
  }

  if (mediaField is String) {
    if (mediaField.trim().isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(mediaField);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
    } catch (_) {
      return [mediaField];
    }
    return [mediaField];
  }

  return [mediaField.toString()];
}

Map<String, dynamic>? _parseSound(dynamic soundField) {
  if (soundField == null) {
    return null;
  }
  if (soundField is Map<String, dynamic>) {
    return soundField;
  }
  if (soundField is String && soundField.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(soundField);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return {'value': soundField};
    }
  }
  return null;
}

DateTime _parseDate(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}

class Post {
  int pId;
  int vId;
  String vName;
  String vUsername;
  String discription;
  DateTime postTime;
  int reach;
  List<String> media;
  Map<String, dynamic>? sound;
  List<Map<String, dynamic>> reactions;
  List<Map<String, dynamic>> comments;
  bool statuse;

  Post({
    required this.pId,
    required this.vId,
    required this.vName,
    required this.vUsername,
    required this.discription,
    required this.postTime,
    this.reach = 0,
    this.media = const [],
    this.sound,
    this.reactions = const [],
    this.comments = const [],
    this.statuse = true,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      pId: json['p_id'] ?? json['pId'] ?? 0,
      vId: json['v_id'] ?? json['vId'] ?? 0,
      vName: json['v_name'] ?? json['vName'] ?? '',
      vUsername: json['v_username'] ?? json['vUsername'] ?? '',
      discription: json['discription'] ?? json['description'] ?? '',
      postTime: _parseDate(json['post_time'] ?? json['postTime'] ?? json['created_at']),
      reach: json['reach'] ?? 0,
      media: _parseMediaList(json['media']),
      sound: _parseSound(json['sound']),
      reactions: List<Map<String, dynamic>>.from(json['reactions'] ?? []),
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
      statuse: json['statuse'] ?? true,
    );
  }
}

class Story {
  int sId;
  int vId;
  String vName;
  String vUsername;
  String sLink;
  DateTime sTime;
  DateTime expiresAt;

  Story({
    required this.sId,
    required this.vId,
    required this.vName,
    required this.vUsername,
    required this.sLink,
    required this.sTime,
    required this.expiresAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    final createdAt = _parseDate(json['s_time'] ?? json['created_at']);
    final expiresAt = json['expires_at'] != null
        ? _parseDate(json['expires_at'])
        : createdAt.add(const Duration(hours: 24));

    return Story(
      sId: json['s_id'] ?? json['sId'] ?? 0,
      vId: json['v_id'] ?? json['vId'] ?? 0,
      vName: json['v_name'] ?? json['vName'] ?? '',
      vUsername: json['v_username'] ?? json['vUsername'] ?? '',
      sLink: json['s_link'] ?? json['media'] ?? '',
      sTime: createdAt,
      expiresAt: expiresAt,
    );
  }
}

class Note {
  int poId;
  int vId;
  String vName;
  String vUsername;
  String noteContent;
  DateTime noteTime;
  String visibility;
  int reactionCount;

  Note({
    required this.poId,
    required this.vId,
    required this.vName,
    required this.vUsername,
    required this.noteContent,
    required this.noteTime,
    this.visibility = 'public',
    this.reactionCount = 0,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      poId: json['po_id'] ?? 0,
      vId: json['v_id'] ?? 0,
      vName: json['v_name'] ?? '',
      vUsername: json['v_username'] ?? '',
      noteContent: json['note_content'] ?? '',
      noteTime: DateTime.parse(json['note_time'] ?? DateTime.now().toIso8601String()),
      visibility: json['visibility'] ?? 'public',
      reactionCount: json['reactionCount'] ?? 0,
    );
  }
}

class Sound {
  int? sId;
  int? spId;
  String? spName;
  String? spDiscription;
  String? sLink;
  String? spLink;
  String? sAName;
  String? lyrics;
  int usageCount;

  Sound({
    this.sId,
    this.spId,
    this.spName,
    this.spDiscription,
    this.sLink,
    this.spLink,
    this.sAName,
    this.lyrics,
    this.usageCount = 0,
  });

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      sId: json['s_id'],
      spId: json['sp_id'],
      spName: json['sp_name'],
      spDiscription: json['sp_discription'],
      sLink: json['s_link'],
      spLink: json['sp_link'],
      sAName: json['s_a_name'],
      lyrics: json['lyrics'],
      usageCount: json['usageCount'] ?? 0,
    );
  }
}

class Comment {
  int postCommentId;
  int postId;
  int vId;
  String vName;
  String vUsername;
  String postCommentText;
  DateTime createdAt;
  List<Comment> replies;
  List<Map<String, dynamic>> reactions;

  Comment({
    required this.postCommentId,
    required this.postId,
    required this.vId,
    required this.vName,
    required this.vUsername,
    required this.postCommentText,
    required this.createdAt,
    this.replies = const [],
    this.reactions = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postCommentId: json['post_comment_id'] ?? json['c_id'] ?? json['cId'] ?? 0,
      postId: json['post_id'] ?? json['p_id'] ?? json['pId'] ?? 0,
      vId: json['v_id'] ?? json['vId'] ?? 0,
      vName: json['v_name'] ?? json['vName'] ?? '',
      vUsername: json['v_username'] ?? json['vUsername'] ?? '',
      postCommentText: json['post_comment_text'] ?? json['content'] ?? '',
      createdAt: _parseDate(json['created_at']),
      replies: (json['replies'] as List?)?.map((r) => Comment.fromJson(r)).toList() ?? [],
      reactions: List<Map<String, dynamic>>.from(json['reactions'] ?? []),
    );
  }
}
