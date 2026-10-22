import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

// ENHANCEMENT 3: comments on a post, read and written through the API.
class CommentService {
  // GET /posts/{id}/comments.
  Future<List<Comment>> getComments(int postId) async {
    final uri = Uri.parse('$host/posts/$postId/comments');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List commentsJson = jsonDecode(response.body)['comments'] ?? [];
      return commentsJson.map((c) => Comment.fromJson(c)).toList();
    }
    throw Exception('Failed to load comments: ${response.statusCode}');
  }

  // POST /comments/add. The API echoes the comment back without storing it.
  Future<Comment> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$host/comments/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Comment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add comment: ${response.statusCode}');
  }
}
