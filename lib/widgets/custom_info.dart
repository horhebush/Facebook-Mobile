import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_font.dart';

// One notification row: who did what, and on which post.
class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.action,
    required this.description,
    this.profileImageUrl = '',
    this.postTitle = '',
    required this.onTap,
  });

  final String name;
  final String action;
  final String description;
  final String profileImageUrl;
  final String postTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: profileImageUrl.isEmpty
                  ? null
                  : CachedNetworkImageProvider(profileImageUrl),
              child: profileImageUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: name,
                    fontSize: 16.sp,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                  CustomFont(
                    text: action,
                    fontSize: 13.sp,
                    color: scheme.onSurface,
                  ),
                  CustomFont(
                    text: description,
                    fontSize: 12.sp,
                    color: scheme.onSurface,
                    fontStyle: FontStyle.italic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  CustomFont(
                    text: postTitle,
                    fontSize: 12.sp,
                    color: scheme.onSurfaceVariant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.more_horiz, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
