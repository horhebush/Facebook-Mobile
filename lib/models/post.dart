// One post from the API.
class Post {
  final int id;
  final int postId;
  final int userId;
  final String title;
  final String body;
  final int likes;
  final int dislikes;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.postId,
    required this.userId,
    required this.title,
    required this.body,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Reads a post whether the reactions are nested or flat.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? json['post_id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      likes: (json['reactions'] != null && json['reactions']['likes'] != null)
          ? (json['reactions']['likes'] as num).toInt()
          : (json['likes'] as num?)?.toInt() ?? 0,
      dislikes:
          (json['reactions'] != null && json['reactions']['dislikes'] != null)
          ? (json['reactions']['dislikes'] as num).toInt()
          : (json['dislikes'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] ?? json['created_at'] ?? '',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '',
    );
  }

  // Turns the post back into JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'title': title,
      'body': body,
      'reactions': {'likes': likes, 'dislikes': dislikes},
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
