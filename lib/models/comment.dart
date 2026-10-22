// One comment on a post, with the user who wrote it.
class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final int userId;
  final String username;
  final String fullName;

  Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.userId,
    required this.username,
    required this.fullName,
  });

  // Reads a comment, including the nested user object the API sends.
  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return Comment(
      id: json['id'] ?? 0,
      body: json['body'] ?? '',
      postId: json['postId'] ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      userId: user['id'] ?? 0,
      username: user['username'] ?? '',
      fullName: user['fullName'] ?? '',
    );
  }

  // Turns the comment back into JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'postId': postId,
      'likes': likes,
      'user': {'id': userId, 'username': username, 'fullName': fullName},
    };
  }
}
