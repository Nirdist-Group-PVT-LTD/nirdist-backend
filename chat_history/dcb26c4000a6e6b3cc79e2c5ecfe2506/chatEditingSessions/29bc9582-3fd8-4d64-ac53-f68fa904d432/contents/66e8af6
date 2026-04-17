class User {
  int vId;
  String vName;
  String vUsername;
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
      vId: json['v_id'] ?? 0,
      vName: json['v_name'] ?? '',
      vUsername: json['v_username'] ?? '',
      vBirth: json['v_birth'] != null ? DateTime.parse(json['v_birth']) : null,
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
    'v_birth': vBirth?.toIso8601String(),
    'emails': emails,
    'phones': phones,
    'usernames': usernames,
    'followerCount': followerCount,
    'followingCount': followingCount,
    'postCount': postCount,
  };
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
      pId: json['p_id'] ?? 0,
      vId: json['v_id'] ?? 0,
      vName: json['v_name'] ?? '',
      vUsername: json['v_username'] ?? '',
      discription: json['discription'] ?? '',
      postTime: DateTime.parse(json['post_time'] ?? DateTime.now().toIso8601String()),
      reach: json['reach'] ?? 0,
      media: List<String>.from(json['media']?.map((m) => m['p_m_link'] ?? '') ?? []),
      sound: json['sound'],
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
    return Story(
      sId: json['s_id'] ?? 0,
      vId: json['v_id'] ?? 0,
      vName: json['v_name'] ?? '',
      vUsername: json['v_username'] ?? '',
      sLink: json['s_link'] ?? '',
      sTime: DateTime.parse(json['s_time'] ?? DateTime.now().toIso8601String()),
      expiresAt: DateTime.parse(json['expires_at'] ?? DateTime.now().toIso8601String()),
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
      postCommentId: json['post_comment_id'] ?? 0,
      postId: json['post_id'] ?? 0,
      vId: json['v_id'] ?? 0,
      vName: json['v_name'] ?? '',
      vUsername: json['v_username'] ?? '',
      postCommentText: json['post_comment_text'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      replies: (json['replies'] as List?)?.map((r) => Comment.fromJson(r)).toList() ?? [],
      reactions: List<Map<String, dynamic>>.from(json['reactions'] ?? []),
    );
  }
}
