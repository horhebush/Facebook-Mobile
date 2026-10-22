import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_info.dart';
import '../widgets/pawbook_loading.dart';
import 'detail_screen.dart';

// ENHANCEMENT 3: every comment left on the signed-in user's posts.
class NotificationScreen extends StatefulWidget {
  final User user;

  const NotificationScreen({super.key, required this.user});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<(Post, Comment)>> _future = _load();

  // Fetches the user's posts, then the comments under each one.
  Future<List<(Post, Comment)>> _load() async {
    final posts = await PostService().getPostsByUser(widget.user.id);
    final items = <(Post, Comment)>[];
    for (final post in posts) {
      final comments = await CommentService().getComments(post.id);
      items.addAll(comments.map((c) => (post, c)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<(Post, Comment)>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: PawbookLoading());
        }
        if (snapshot.hasError) {
          return _message(
            '$snapshot.error'.replaceFirst('Exception: ', ''),
            retry: true,
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return _message('No one has barked at your posts yet.');
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() => _future = _load());
            await _future;
          },
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final (post, comment) = items[index];
              return CustomInformation(
                name: comment.fullName,
                action: 'commented on your post',
                description: comment.body,
                profileImageUrl: avatarUrl(comment.username),
                postTitle: post.title,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailScreen(post: post, author: widget.user),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Centered text for the empty and error states.
  Widget _message(String text, {bool retry = false}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none, size: 48.sp, color: FB_PRIMARY),
          SizedBox(height: 8.h),
          CustomFont(
            text: text,
            fontSize: 13.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          if (retry)
            TextButton(
              onPressed: () => setState(() => _future = _load()),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
