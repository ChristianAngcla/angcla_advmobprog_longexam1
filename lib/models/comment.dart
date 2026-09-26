class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final int userId;
  final String username;
  final String fullName;

  const Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.userId,
    required this.username,
    required this.fullName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final Map<String, dynamic> user = userJson is Map
        ? Map<String, dynamic>.from(userJson)
        : <String, dynamic>{};

    return Comment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      body: json['body']?.toString() ?? '',
      postId: (json['postId'] as num?)?.toInt() ??
          (json['post_id'] as num?)?.toInt() ??
          0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      userId: (user['id'] as num?)?.toInt() ??
          (json['userId'] as num?)?.toInt() ??
          (json['user_id'] as num?)?.toInt() ??
          0,
      username: user['username']?.toString() ??
          json['username']?.toString() ??
          '',
      fullName: user['fullName']?.toString() ??
          json['fullName']?.toString() ??
          json['full_name']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'postId': postId,
      'likes': likes,
      'user': {
        'id': userId,
        'username': username,
        'fullName': fullName,
      },
    };
  }

  Comment copyWith({
    int? id,
    String? body,
    int? postId,
    int? likes,
    int? userId,
    String? username,
    String? fullName,
  }) {
    return Comment(
      id: id ?? this.id,
      body: body ?? this.body,
      postId: postId ?? this.postId,
      likes: likes ?? this.likes,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
    );
  }
}
