import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/post.dart';

// Reads posts from the API and remembers which ones this device liked.
class PostService {
  // GET /posts, paged.
  Future<List<Post>> getPosts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$host/posts?limit=$limit&skip=$skip');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  // ENHANCEMENT 2: GET /posts/user/{id}, the posts one user wrote.
  Future<List<Post>> getPostsByUser(int userId) async {
    final uri = Uri.parse('$host/posts/user/$userId');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List postsJson = jsonDecode(response.body)['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  // ENHANCEMENT 3: ids of the posts liked on this device.
  static final Set<int> likedIds = {};

  // Reads the liked ids back from the device, before the first frame.
  Future<void> loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    likedIds
      ..clear()
      ..addAll((prefs.getStringList('likedPosts') ?? []).map(int.parse));
  }

  bool isLiked(int postId) => likedIds.contains(postId);

  // The count to show: the API's count plus this device's like.
  int likesOf(Post post) => post.likes + (isLiked(post.id) ? 1 : 0);

  // Flips the like, saves it, and sends the new count to the API.
  Future<void> toggleLike(Post post) async {
    final liked = !isLiked(post.id);
    if (liked) {
      likedIds.add(post.id);
    } else {
      likedIds.remove(post.id);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'likedPosts',
      likedIds.map((id) => '$id').toList(),
    );

    // dummyjson simulates the write: it answers with the updated post but
    // stores nothing, so the saved id above is what makes the like stick.
    try {
      await patch(
        Uri.parse('$host/posts/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reactions': {'likes': likesOf(post), 'dislikes': post.dislikes},
        }),
      );
    } catch (_) {}
  }
}
