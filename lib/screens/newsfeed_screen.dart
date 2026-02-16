import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';
import '../constants.dart';

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  List<NewsFeedCard> get _posts => const [
        NewsFeedCard(
          userName: 'Max the Golden',
          postContent:
              'Just had the best zoomies at the dog park! 🐕 Who else loves chasing squirrels? They never let me catch them though... 😤',
          numOfLikes: 142,
          date: '2 hrs ago',
          avatarUrl: 'assets/images/image.png',
          hasImage: true,
          imageUrl: 'assets/images/8ymcelbzhjqa1.jpg',
        ),
        NewsFeedCard(
          userName: 'Princess Whiskers',
          postContent:
              'My human thinks the laptop is for "work" but we all know it\'s actually a heated bed for cats. Currently occupying it. No regrets. 🐱💅',
          numOfLikes: 89,
          date: '3 hrs ago',
          avatarUrl: 'assets/images/owl.jpg',
          hasImage: true,
          imageUrl:
              'assets/images/random-dog-i-found-on-a-hike-v0-5yza8uje7u2c1.jpg.webp',
        ),
        NewsFeedCard(
          userName: 'Buddy the Beagle',
          postContent:
              'SOMEONE LEFT THE TREAT JAR OPEN! This is not a drill! I repeat, THIS IS NOT A DRILL! 🦴🎉',
          numOfLikes: 256,
          date: '5 hrs ago',
          avatarUrl: 'assets/images/manu_rios.jpg',
          hasImage: true,
          imageUrl: 'assets/images/owl.jpg',
        ),
        NewsFeedCard(
          userName: 'Sir Fluffington III',
          postContent:
              'Grooming day was a disaster. They gave me a lion cut. A LION CUT. I am a Persian cat of dignity. This is unacceptable. 😾',
          numOfLikes: 312,
          date: '6 hrs ago',
          avatarUrl: 'assets/images/image.png',
          hasImage: true,
          imageUrl: 'assets/images/images-7.jpeg',
        ),
        NewsFeedCard(
          userName: 'Luna the Labrador',
          postContent:
              'Just learned that "bath time" and "beach time" are NOT the same thing. Very disappointed. Still a good girl though. 🐶🛁',
          numOfLikes: 178,
          date: 'Yesterday',
          avatarUrl: 'assets/images/image.png',
          hasImage: true,
          imageUrl: 'assets/images/scale;webp=auto;jpeg_quality=60.jpg.webp',
        ),
        NewsFeedCard(
          userName: 'Cheddar the Corgi',
          postContent:
              'My legs may be short but my heart is full! Just got adopted today and I already love my new family! 🧡🐾',
          numOfLikes: 524,
          date: 'Yesterday',
          avatarUrl: 'assets/images/manu_rios.jpg',
          hasImage: true,
          imageUrl: 'assets/images/images-8.jpeg',
        ),
      ];

  List<_AdData> get _adItems => const [
        _AdData(
          title: 'Ikaw na ito!',
          imageUrl:
              'https://www.petplace.com/article/breed/media_15ad72c2fdb39acf09aafa9934912c89bfa08665a.jpeg?width=1200&format=pjpg&optimize=medium',
          profileUrl:
              'https://image.petmd.com/files/inline-images/shiba-inu-black-and-tan-colors.jpg?VersionId=pLq84BE0jdMjXeDCUJJJLPuIWYsVMUU',
          description: 'Kamusta? Check out the latest treats for your pup.',
        ),
        _AdData(
          title: 'Holiday Sale',
          imageUrl:
              'https://images.unsplash.com/photo-1558788353-f76d92427f16?auto=format&fit=crop&w=1200&q=80',
          profileUrl:
              'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=400&q=80',
          description: 'Gifts for good boys & girls start here.',
        ),
        _AdData(
          title: 'Adopt Me',
          imageUrl:
              'https://images.unsplash.com/photo-1507146426996-ef05306b995a?auto=format&fit=crop&w=1200&q=80',
          profileUrl:
              'https://images.unsplash.com/photo-1504208434309-cb69f4fe52b0?auto=format&fit=crop&w=400&q=80',
          description: 'Find your new best friend today.',
        ),
        _AdData(
          title: 'Grooming Day',
          imageUrl:
              'https://images.unsplash.com/photo-1619983081563-430f63602796?auto=format&fit=crop&w=1200&q=80',
          profileUrl:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=400&q=80',
          description: 'Book spa slots before the weekend rush.',
        ),
        _AdData(
          title: 'Vet Online',
          imageUrl:
              'https://images.unsplash.com/photo-1534351590666-13e3e96b5017?auto=format&fit=crop&w=1200&q=80',
          profileUrl:
              'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=400&q=80',
          description: '24/7 chat with licensed vets.',
        ),
        _AdData(
          title: 'Training 101',
          imageUrl:
              'https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?auto=format&fit=crop&w=1200&q=80',
          profileUrl:
              'https://images.unsplash.com/photo-1558944351-c0d0571b51f0?auto=format&fit=crop&w=400&q=80',
          description: 'Positive reinforcement classes near you.',
        ),
      ];

  List<Widget> _buildAlternatingFeed() {
    final List<Widget> feed = [];
    final maxPairs = 4; // alternate 3-4 times depending on posts available
    int adCount = 0;

    for (var i = 0; i < _posts.length; i++) {
      feed.add(_posts[i]);
      final canShowAd = adCount < maxPairs && adCount < _adItems.length;
      if (canShowAd) {
        feed.add(_AdvertisementSection(
          items: _adItems,
        ));
        adCount++;
      }
    }
    return feed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FB_LIGHT_PRIMARY.withOpacity(0.5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildAlternatingFeed(),
      ),
    );
  }
}

void _showAdModal(BuildContext context, _AdData ad) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: FB_TEXT_COLOR_WHITE,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ScreenUtil().radius(20))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: ScreenUtil().setHeight(12)),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ScreenUtil().radius(12)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ad.imageUrl,
                      width: double.infinity,
                      height: ScreenUtil().setHeight(220),
                      fit: BoxFit.cover,
                      placeholder: (context, _) => SizedBox(
                        height: ScreenUtil().setHeight(220),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, _, __) => SizedBox(
                        height: ScreenUtil().setHeight(220),
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: ScreenUtil().radius(20),
                              backgroundImage: CachedNetworkImageProvider(ad.profileUrl),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(12)),
                            Expanded(
                              child: CustomFont(
                                text: ad.title,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(12)),
                        CustomFont(
                          text: ad.description,
                          fontSize: ScreenUtil().setSp(15),
                          color: FB_TEXT_COLOR_DARKGREY,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            label: const Text('Close'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: FB_PRIMARY,
                              side: BorderSide(color: FB_PRIMARY),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AdvertisementSection extends StatelessWidget {
  const _AdvertisementSection({required this.items});

  final List<_AdData> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(10),
        vertical: ScreenUtil().setSp(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: 'Advertisement/ Promotion',
            fontSize: ScreenUtil().setSp(13),
            fontWeight: FontWeight.bold,
            color: FB_TEXT_COLOR_DARKGREY,
          ),
          SizedBox(height: ScreenUtil().setHeight(6)),
          CarouselSlider(
            options: CarouselOptions(
              height: ScreenUtil().setHeight(230),
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              padEnds: false,
            ),
            items: items
                .map(
                  (ad) => _AdCard(
                    title: ad.title,
                    description: ad.description,
                    imageUrl: ad.imageUrl,
                    profileUrl: ad.profileUrl,
                    onTap: () => _showAdModal(context, ad),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  const _AdCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.profileUrl,
    required this.onTap,
  });

  final String title;
  final String description;
  final String imageUrl;
  final String profileUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shadowColor: FB_PRIMARY.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().radius(12)),
                topRight: Radius.circular(ScreenUtil().radius(12)),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: ScreenUtil().setHeight(130),
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, _) => SizedBox(
                  height: ScreenUtil().setHeight(130),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, _, __) => SizedBox(
                  height: ScreenUtil().setHeight(130),
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: ScreenUtil().radius(16),
                    backgroundImage: CachedNetworkImageProvider(profileUrl),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: title,
                          fontSize: ScreenUtil().setSp(13),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        CustomFont(
                          text: description,
                          fontSize: ScreenUtil().setSp(11),
                          color: FB_TEXT_COLOR_DARKGREY,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.campaign, color: FB_PRIMARY, size: ScreenUtil().setSp(20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdData {
  const _AdData({
    required this.title,
    required this.imageUrl,
    required this.profileUrl,
    required this.description,
  });

  final String title;
  final String imageUrl;
  final String profileUrl;
  final String description;
}
