import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../screens/detail_screen.dart';
import 'custom_font.dart';

class NewsFeedCard extends StatelessWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final bool hasImage;
  final String? avatarPath;
  final String? imagePath;
  final String? avatarUrl;
  final String? imageUrl;

  const NewsFeedCard({
    super.key,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    this.hasImage = false,
    required this.date,
    this.avatarPath,
    this.imagePath,
    this.avatarUrl,
    this.imageUrl,
  });

  ImageProvider<Object>? _avatarImage() {
    if (avatarPath != null) {
      return AssetImage(avatarPath!);
    }
    if (avatarUrl != null) {
      return avatarUrl!.startsWith('http')
          ? CachedNetworkImageProvider(avatarUrl!)
          : AssetImage(avatarUrl!);
    }
    return null;
  }

  String _getProfileImageUrl() {
    if (avatarUrl != null) return avatarUrl!;
    if (avatarPath != null) return avatarPath!;
    return '';
  }

  String _getPostImageUrl() {
    if (imageUrl != null) return imageUrl!;
    if (imagePath != null) return imagePath!;
    return '';
  }

  Widget _buildPostImage(double height) {
    if (imageUrl != null) {
      final url = imageUrl!;
      if (url.startsWith('http')) {
        return _loadingAwareNetworkImage(url, height: height);
      }
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      );
    }
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = _avatarImage();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              userName: userName,
              postContent: postContent,
              date: date,
              numOfLikes: numOfLikes,
              imageUrl: _getPostImageUrl(),
              profileImageURL: _getProfileImageUrl(),
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        elevation: 2,
        shadowColor: FB_PRIMARY.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatarImage != null
                      ? CircleAvatar(
                          radius: ScreenUtil().radius(16),
                          backgroundImage: avatarImage,
                        )
                      : const Icon(Icons.person),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: date,
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          const Icon(Icons.public, color: Colors.grey, size: 15),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(5)),

              // Post Content
              CustomFont(
                text: postContent,
                fontSize: ScreenUtil().setSp(12),
                color: Colors.black,
              ),

              SizedBox(height: ScreenUtil().setHeight(5)),

              if (hasImage && (imagePath != null || imageUrl != null))
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                    child: _buildPostImage(ScreenUtil().setHeight(200)),
                  ),
                )
              else
                SizedBox(height: ScreenUtil().setHeight(1)),

              _InteractionRow(numOfLikes: numOfLikes),

              Row(
                children: [
                  avatarImage != null
                      ? CircleAvatar(
                          radius: ScreenUtil().radius(12),
                          backgroundImage: avatarImage,
                        )
                      : const Icon(Icons.person),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Container(
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(10), 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setWidth(330),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setSp(10)),
                      ),
                    ),
                    child: CustomFont(
                      text: 'Write a comment...',
                      fontSize: ScreenUtil().setSp(11),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomFont(
                text: 'View comments',
                fontSize: ScreenUtil().setSp(12),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _loadingAwareNetworkImage(String url, {required double height}) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    width: double.infinity,
    height: height,
    placeholder: (context, _) => SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, _, __) => SizedBox(
      height: height,
      child: const Center(child: Icon(Icons.broken_image)),
    ),
  );
}

class _InteractionRow extends StatelessWidget {
  const _InteractionRow({required this.numOfLikes});

  final int numOfLikes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Like button with paw
          Row(
            children: [
              Icon(Icons.pets, color: FB_PRIMARY, size: 22),
              SizedBox(width: ScreenUtil().setWidth(6)),
              CustomFont(
                text: '$numOfLikes Woofs',
                fontSize: ScreenUtil().setSp(12),
                color: FB_TEXT_COLOR_DARKGREY,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          // Comment button
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: FB_PRIMARY, size: 20),
              SizedBox(width: ScreenUtil().setWidth(6)),
              CustomFont(
                text: 'Bark',
                fontSize: ScreenUtil().setSp(12),
                color: FB_TEXT_COLOR_DARKGREY,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          // Share button
          Row(
            children: [
              Icon(Icons.share_outlined, color: FB_PRIMARY, size: 20),
              SizedBox(width: ScreenUtil().setWidth(6)),
              CustomFont(
                text: 'Share',
                fontSize: ScreenUtil().setSp(12),
                color: FB_TEXT_COLOR_DARKGREY,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
