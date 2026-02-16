import 'package:activity_1/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_font.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageURL;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.imageUrl = '',
    this.profileImageURL = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _likeCount;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.numOfLikes;
  }

  ImageProvider _getProfileImage() {
    if (widget.profileImageURL.startsWith('http')) {
      return CachedNetworkImageProvider(widget.profileImageURL);
    }
    return AssetImage(widget.profileImageURL);
  }

  ImageProvider _getPostImage() {
    if (widget.imageUrl.startsWith('http')) {
      return CachedNetworkImageProvider(widget.imageUrl);
    }
    return AssetImage(widget.imageUrl);
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likeCount--;
        _isLiked = false;
      } else {
        _likeCount++;
        _isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomFont(
          text: widget.userName,
          fontSize: ScreenUtil().setSp(20),
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Colors.white,
        height: ScreenUtil().screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (widget.imageUrl == '')
                  ? SizedBox(
                      height: ScreenUtil().setHeight(0),
                    )
                  : Image(image: _getPostImage()),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (widget.profileImageURL == '')
                        ? const Icon(Icons.person)
                        : CircleAvatar(
                            radius: ScreenUtil().setSp(25),
                            backgroundImage: _getProfileImage(),
                          ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: widget.userName,
                          fontSize: ScreenUtil().setSp(20),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomFont(
                              text: widget.date,
                              fontSize: ScreenUtil().setSp(15),
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(3),
                            ),
                            Icon(
                              Icons.public,
                              color: Colors.grey,
                              size: ScreenUtil().setSp(18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.more_horiz),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: CustomFont(
                  text: widget.postContent,
                  fontSize: ScreenUtil().setSp(18),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              Divider(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        Icons.pets,
                        color: _isLiked ? FB_DARK_PRIMARY : Colors.grey,
                      ),
                      label: CustomFont(
                        text: (_likeCount == 0) ? 'Paw' : _likeCount.toString(),
                        fontSize: ScreenUtil().setSp(12),
                        color: _isLiked ? FB_DARK_PRIMARY : Colors.grey,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment,
                        color: FB_DARK_PRIMARY,
                      ),
                      label: CustomFont(
                        text: 'Comment',
                        fontSize: ScreenUtil().setSp(12),
                        color: FB_DARK_PRIMARY,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.redo,
                        color: FB_DARK_PRIMARY,
                      ),
                      label: CustomFont(
                        text: 'Share',
                        fontSize: ScreenUtil().setSp(12),
                        color: FB_DARK_PRIMARY,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
