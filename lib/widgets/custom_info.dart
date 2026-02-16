import 'package:activity_1/widgets/custom_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/detail_screen.dart';

class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.profileImageUrl = '',
    this.atProfile = false,
    required this.date,
    this.imageUrl = '',
    required this.numOfLikes,
  });

  final String name;
  // Post Title
  final String post;
  // Post Content
  final String description;
  final String profileImageUrl;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final bool atProfile;

  ImageProvider? _getProfileImage() {
    if (profileImageUrl.isEmpty) return null;
    if (profileImageUrl.startsWith('http')) {
      return NetworkImage(profileImageUrl);
    }
    return AssetImage(profileImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _getProfileImage();

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: InkWell(
        onTap: () {
          (atProfile)
              ? print('')
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      userName: name,
                      postContent: description,
                      date: date,
                      numOfLikes: numOfLikes,
                      imageUrl: imageUrl,
                      profileImageURL: profileImageUrl,
                    ),
                  ),
                );
        },
        child: Row(
          children: [
            (profileImage == null)
                ? const Icon(Icons.person)
                : CircleAvatar(
                    radius: ScreenUtil().setSp(15),
                    backgroundImage: profileImage,
                  ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: name,
                    fontSize: ScreenUtil().setSp(20),
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  CustomFont(
                    text: 'Posted: $post',
                    fontSize: ScreenUtil().setSp(13),
                    color: Colors.black,
                  ),
                  CustomFont(
                    text: description,
                    fontSize: ScreenUtil().setSp(12),
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  CustomFont(
                    text: date,
                    fontSize: ScreenUtil().setSp(12),
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
