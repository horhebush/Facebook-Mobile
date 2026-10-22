import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../screens/detail_screen.dart';
import '../services/post_service.dart';
import 'custom_font.dart';

// One post in the feed. The like is clickable; the rest opens the comments.
class PostCard extends StatefulWidget {
  final Post post;
  final User? author;

  const PostCard({super.key, required this.post, this.author});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostService _postService = PostService();
  late bool _liked = _postService.isLiked(widget.post.id);
  late int _likes = _postService.likesOf(widget.post);

  // ENHANCEMENT 3: flips the like on screen and hands it to the service.
  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
    _postService.toggleLike(widget.post);
  }

  // Opens the post. The like can change there, so re-read it on the way back.
  Future<void> _openDetail() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(post: widget.post, author: widget.author),
      ),
    );
    if (!mounted) return;
    setState(() {
      _liked = _postService.isLiked(widget.post.id);
      _likes = _postService.likesOf(widget.post);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final post = widget.post;
    final author = widget.author;
    final image = author?.image ?? '';

    return Card(
      margin: EdgeInsets.all(10.r),
      elevation: 2,
      shadowColor: FB_PRIMARY.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: scheme.surfaceContainerLowest,
      child: InkWell(
        onTap: _openDetail,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar from the users endpoint, or a placeholder.
                  CircleAvatar(
                    radius: 16.r,
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
                          fontSize: 15.sp,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            CustomFont(
                              text: '@${author?.username ?? post.userId}',
                              fontSize: 12.sp,
                              color: scheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 3.w),
                            Icon(
                              Icons.public,
                              color: scheme.onSurfaceVariant,
                              size: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: scheme.onSurfaceVariant),
                ],
              ),
              SizedBox(height: 8.h),
              CustomFont(
                text: post.title,
                fontSize: 14.sp,
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 4.h),
              CustomFont(
                text: post.body,
                fontSize: 12.sp,
                color: scheme.onSurface,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _action(
                    icon: _liked ? Icons.pets : Icons.pets_outlined,
                    label: '$_likes Woofs',
                    color: _liked ? FB_PRIMARY : scheme.onSurfaceVariant,
                    onPressed: _toggleLike,
                  ),
                  _action(
                    icon: Icons.chat_bubble_outline,
                    label: 'Bark',
                    color: scheme.onSurfaceVariant,
                    onPressed: _openDetail,
                  ),
                  _action(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: scheme.onSurfaceVariant,
                    onPressed: () {},
                  ),
                ],
              ),
              InkWell(
                onTap: _openDetail,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.centerLeft,
                  height: 28.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: CustomFont(
                    text: 'Write a comment...',
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Like, comment and share share one shape.
  Widget _action({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      label: CustomFont(
        text: label,
        fontSize: 12.sp,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
