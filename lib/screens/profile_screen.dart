import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/pawbook_loading.dart';
import '../widgets/post_card.dart';

// ENHANCEMENT 2: the signed-in user's profile, with their posts from the API.
class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Post>> _posts = PostService().getPostsByUser(widget.user.id);

  static const String _coverImage = 'assets/images/images-7.jpeg';
  static const List<String> _photos = [
    'assets/images/8ymcelbzhjqa1.jpg',
    'assets/images/owl.jpg',
    'assets/images/images-8.jpeg',
  ];

  // Clears the saved session and returns to sign-in.
  Future<void> _signOut() async {
    await UserService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = widget.user;

    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: 20.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: scheme.surface,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user.image.isEmpty
                              ? null
                              : CachedNetworkImageProvider(user.image),
                          child: user.image.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: scheme.surfaceContainerHigh,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 55.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: user.fullName,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: scheme.onSurface,
                  ),
                  CustomFont(
                    text: '@${user.username}',
                    fontSize: 14.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 5.h),
                  FutureBuilder<List<Post>>(
                    future: _posts,
                    builder: (context, snapshot) {
                      final posts = snapshot.data ?? [];
                      final woofs = posts.fold(0, (sum, p) => sum + p.likes);
                      return Row(
                        children: [
                          _stat('${posts.length}', 'posts'),
                          SizedBox(width: 5.w),
                          Icon(Icons.circle, size: 5.sp, color: Colors.grey),
                          SizedBox(width: 5.w),
                          _stat('$woofs', 'woofs'),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CustomButton(
                        buttonName: 'Settings',
                        fontColor: Colors.white,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                      ),
                      SizedBox(width: 10.w),
                      CustomButton(
                        buttonName: 'Sign Out',
                        buttonType: 'outlined',
                        fontColor: scheme.onSurface,
                        outlineColor: scheme.outline,
                        onPressed: () => customOptionDialog(
                          context,
                          title: 'Sign out?',
                          content: 'You will need to sign in again next time.',
                          onYes: _signOut,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            TabBar(
              indicatorColor: FB_PRIMARY,
              indicatorWeight: 3,
              labelColor: FB_PRIMARY,
              unselectedLabelColor: scheme.onSurfaceVariant,
              tabs: const [
                Tab(icon: Icon(Icons.article_outlined), text: 'Posts'),
                Tab(icon: Icon(Icons.pets), text: 'About'),
                Tab(icon: Icon(Icons.photo_library_outlined), text: 'Photos'),
              ],
            ),
            SizedBox(
              height: 400.h,
              child: TabBarView(
                children: [
                  _postsTab(user),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('Username', user.username),
                        _infoRow('Email', user.email),
                        _infoRow('Gender', user.gender),
                        _infoRow('User ID', '${user.id}'),
                      ],
                    ),
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: _photos.map(_photoTile).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // The user's own posts, rendered with the same card as the feed.
  Widget _postsTab(User user) {
    return FutureBuilder<List<Post>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: PawbookLoading());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFont(
                  text: '$snapshot.error'.replaceFirst('Exception: ', ''),
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => setState(
                    () => _posts = PostService().getPostsByUser(user.id),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return Center(
            child: CustomFont(
              text: 'No posts yet.',
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }
        return ListView(
          children: posts.map((p) => PostCard(post: p, author: user)).toList(),
        );
      },
    );
  }

  // A number with its label, for the stats row.
  Widget _stat(String value, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        CustomFont(
          text: value,
          fontSize: 15.sp,
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 6.w),
        CustomFont(
          text: label,
          fontSize: 15.sp,
          color: scheme.onSurfaceVariant,
        ),
      ],
    );
  }

  // One label/value line on the About tab.
  Widget _infoRow(String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: '$label:',
            fontSize: 14.sp,
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomFont(
              text: value.isEmpty ? '-' : value,
              fontSize: 14.sp,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // One photo in the grid; tapping opens it full size.
  Widget _photoTile(String imagePath) {
    return GestureDetector(
      onTap: () => customShowImageDialog(context, imageUrl: imagePath),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}
