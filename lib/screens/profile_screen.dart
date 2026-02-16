import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_dialogs.dart';
import '../services/user_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDatabase _userDatabase = UserDatabase();
  String _displayName = 'Demi'; // Default fallback
  bool _isLoading = true;
  final String _profileImage = 'assets/images/manu_rios.jpg';
  final String _coverImage = 'assets/images/images-7.jpeg';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final username = await _userDatabase.getCurrentUser();
      if (username != null) {
        final user = await _userDatabase.findUserByUsername(username);
        if (user != null) {
          setState(() {
            // Use username as display name, or first name + last name if available
            final firstName = user['firstName']?.toString() ?? '';
            final lastName = user['lastName']?.toString() ?? '';
            if (firstName.isNotEmpty || lastName.isNotEmpty) {
              _displayName = '$firstName $lastName'.trim();
            } else {
              _displayName = username;
            }
            _isLoading = false;
          });
          return;
        }
      }
      // If no user found, keep default
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // On error, keep default
      setState(() {
        _isLoading = false;
      });
    }
  }

  ImageProvider _imageProvider(String source) {
    if (source.startsWith('http')) {
      return CachedNetworkImageProvider(source);
    }
    return AssetImage(source);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: '$label:',
            fontSize: ScreenUtil().setSp(14),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          Expanded(
            child: CustomFont(
              text: value,
              fontSize: ScreenUtil().setSp(14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  static const String _photo1 = 'assets/images/8ymcelbzhjqa1.jpg';
  static const String _photo2 = 'assets/images/owl.jpg';
  static const String _photo3 = 'assets/images/images-8.jpeg';

  Widget _buildPhotoTile(String imagePath) {
    final isNetwork = imagePath.startsWith('http');
    return GestureDetector(
      onTap: () => customShowImageDialog(context, imageUrl: imagePath),
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              placeholder: (context, _) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, _, __) =>
                  const Center(child: Icon(Icons.error)),
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.error)),
            ),
    );
  }

  Widget _photos() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [
        _buildPhotoTile(_photo1),
        _buildPhotoTile(_photo2),
        _buildPhotoTile(_photo3),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: _imageProvider(_coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: ScreenUtil().setWidth(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageProvider(_profileImage),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: _isLoading ? 'Loading...' : _displayName,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(20),
                      color: Colors.black,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Row(
                      children: [
                        CustomFont(
                          text: '867',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'followers', 
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        Icon(
                          Icons.circle,
                          size: ScreenUtil().setSp(5),
                          color: Colors.grey,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        CustomFont(
                          text: '325',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'following',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Row(
                      children: [
                        CustomButton(
                          buttonName: 'Follow',
                          onPressed: () {},
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomButton(
                          buttonName: 'Message',
                          onPressed: () {},
                          buttonType: 'outlined',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              TabBar(
                indicatorColor: FB_PRIMARY,
                indicatorWeight: 3,
                labelColor: FB_PRIMARY,
                unselectedLabelColor: FB_TEXT_COLOR_GREY,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 18),
                        SizedBox(width: 6),
                        CustomFont(
                          text: 'Posts',
                          fontSize: ScreenUtil().setSp(14),
                          color: FB_DARK_PRIMARY,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 18),
                        SizedBox(width: 6),
                        CustomFont(
                          text: 'About',
                          fontSize: ScreenUtil().setSp(14),
                          color: FB_DARK_PRIMARY,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_outlined, size: 18),
                        SizedBox(width: 6),
                        CustomFont(
                          text: 'Photos',
                          fontSize: ScreenUtil().setSp(14),
                          color: FB_DARK_PRIMARY,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(400),
                child: TabBarView(
                  children: [
                    ListView(
                      children: [
                        NewsFeedCard(
                          userName: _displayName,
                          postContent:
                              'Just had the best zoomies at the dog park! 🐕 Who else loves chasing squirrels? They never let me catch them though... 😤',
                          numOfLikes: 142,
                          date: '2 hrs ago',
                          avatarUrl: 'assets/images/manu_rios.jpg',
                          hasImage: true,
                          imageUrl: 'assets/images/8ymcelbzhjqa1.jpg',
                        ),
                        NewsFeedCard(
                          userName: _displayName,
                          postContent:
                              'My human thinks the laptop is for "work" but we all know it\'s actually a heated bed for cats. Currently occupying it. No regrets. 🐱💅',
                          numOfLikes: 89,
                          date: '3 hrs ago',
                          avatarUrl: 'assets/images/image.png',
                          hasImage: true,
                          imageUrl:
                              'assets/images/random-dog-i-found-on-a-hike-v0-5yza8uje7u2c1.jpg.webp',
                        ),
                        NewsFeedCard(
                          userName: _displayName,
                          postContent:
                              'SOMEONE LEFT THE TREAT JAR OPEN! This is not a drill! I repeat, THIS IS NOT A DRILL! 🦴🎉',
                          numOfLikes: 256,
                          date: '5 hrs ago',
                          avatarUrl: 'assets/images/owl.jpg',
                          hasImage: true,
                          imageUrl: 'assets/images/images-7.jpeg',
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Birthdate', 'August 12, 2020'),
                          _buildInfoRow('Breed', 'Jack Russell Terrier'),
                          _buildInfoRow('Favorite Food', 'Aozi Kibbles'),
                        ],
                      ),
                    ),
                    _photos(),
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
