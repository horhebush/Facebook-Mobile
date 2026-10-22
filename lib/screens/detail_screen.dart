import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/pawbook_loading.dart';

// ENHANCEMENT 3: one post with its comments. Likes toggle; comments can be added.
class DetailScreen extends StatefulWidget {
  final Post post;
  final User? author;

  const DetailScreen({super.key, required this.post, this.author});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PostService _postService = PostService();
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();

  late Future<List<Comment>> _comments = _commentService.getComments(
    widget.post.id,
  );
  late bool _liked = _postService.isLiked(widget.post.id);
  late int _likes = _postService.likesOf(widget.post);

  // Comments added from this screen; the API does not store them.
  final List<Comment> _added = [];
  bool _sending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Flips the like on screen and hands it to the service.
  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
    _postService.toggleLike(widget.post);
  }

  // Posts the comment as the signed-in user and shows it once the API answers.
  Future<void> _sendComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);

    try {
      final me = await UserService().getUser();
      final comment = await _commentService.addComment(
        postId: widget.post.id,
        userId: me.id,
        body: body,
      );
      if (!mounted) return;
      setState(() {
        _added.add(comment);
        _commentController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'.replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final post = widget.post;
    final author = widget.author;
    final image = author?.image ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomFont(
          text: author?.fullName ?? 'Post',
          fontSize: 20.sp,
          color: scheme.onSurface,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.r),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: image.isEmpty
                          ? null
                          : CachedNetworkImageProvider(image),
                      child: image.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: author?.fullName ?? 'User ${post.userId}',
                            fontSize: 20.sp,
                            color: scheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              CustomFont(
                                text: '@${author?.username ?? post.userId}',
                                fontSize: 15.sp,
                                color: scheme.onSurfaceVariant,
                              ),
                              SizedBox(width: 3.w),
                              Icon(
                                Icons.public,
                                color: scheme.onSurfaceVariant,
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz, color: scheme.onSurfaceVariant),
                  ],
                ),
                SizedBox(height: 15.h),
                CustomFont(
                  text: post.title,
                  fontSize: 20.sp,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),
                CustomFont(
                  text: post.body,
                  fontSize: 16.sp,
                  color: scheme.onSurface,
                ),
                SizedBox(height: 20.h),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _liked ? Icons.pets : Icons.pets_outlined,
                        color: _liked ? FB_PRIMARY : scheme.onSurfaceVariant,
                      ),
                      label: CustomFont(
                        text: '$_likes Woofs',
                        fontSize: 12.sp,
                        color: _liked ? FB_PRIMARY : scheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.comment, color: brandColor(context)),
                      label: CustomFont(
                        text: 'Comment',
                        fontSize: 12.sp,
                        color: brandColor(context),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.redo, color: brandColor(context)),
                      label: CustomFont(
                        text: 'Share',
                        fontSize: 12.sp,
                        color: brandColor(context),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(height: 10.h),
                CustomFont(
                  text: 'Comments',
                  fontSize: 16.sp,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 6.h),
                FutureBuilder<List<Comment>>(
                  future: _comments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: PawbookLoadingDots());
                    }
                    if (snapshot.hasError) {
                      return _commentsMessage(
                        '$snapshot.error'.replaceFirst('Exception: ', ''),
                        retry: true,
                      );
                    }
                    final comments = [...?snapshot.data, ..._added];
                    if (comments.isEmpty) {
                      return _commentsMessage(
                        'No comments yet. Be the first to bark!',
                      );
                    }
                    return Column(
                      children: comments.map(_commentTile).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          _commentInput(scheme),
        ],
      ),
    );
  }

  // One comment: avatar, name and body in a bubble.
  Widget _commentTile(Comment comment) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundImage: CachedNetworkImageProvider(
              avatarUrl(comment.username),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: comment.fullName,
                    fontSize: 13.sp,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 2.h),
                  CustomFont(
                    text: comment.body,
                    fontSize: 12.sp,
                    color: scheme.onSurface,
                  ),
                  if (comment.likes > 0) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(Icons.pets, size: 12, color: FB_PRIMARY),
                        SizedBox(width: 4.w),
                        CustomFont(
                          text: '${comment.likes}',
                          fontSize: 11.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text for the empty and error states of the comment list.
  Widget _commentsMessage(String text, {bool retry = false}) {
    return Column(
      children: [
        CustomFont(
          text: text,
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          textAlign: TextAlign.center,
        ),
        if (retry)
          TextButton(
            onPressed: () => setState(
              () => _comments = _commentService.getComments(widget.post.id),
            ),
            child: const Text('Retry'),
          ),
      ],
    );
  }

  // The field and send button pinned to the bottom.
  Widget _commentInput(ColorScheme scheme) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendComment(),
                style: TextStyle(fontFamily: 'Frutiger', fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  filled: true,
                  fillColor: scheme.surfaceContainerHigh,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            _sending
                ? Padding(
                    padding: EdgeInsets.all(12.r),
                    child: SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: FB_PRIMARY),
                    onPressed: _sendComment,
                  ),
          ],
        ),
      ),
    );
  }
}
