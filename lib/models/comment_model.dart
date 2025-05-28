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

  // Metode toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'newsId': newsId,
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Metode fromJson()
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      newsId: json['newsId'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Metode toMap() dan fromMap()
  Map<String, dynamic> toMap() => toJson();
  
  factory Comment.fromMap(Map<String, dynamic> map) => Comment.fromJson(map);
}