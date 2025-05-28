class Comment {
  final String id;
  final String newsId;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsId': newsId,
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      newsId: map['newsId'],
      userId: map['userId'],
      username: map['username'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}