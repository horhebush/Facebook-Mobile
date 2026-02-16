import '../widgets/custom_info.dart' as notif;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().screenWidth,
      child: ListView(
        children: [
          // Real post from newsfeed - Max the Golden
          notif.CustomInformation(
            name: 'Max the Golden',
            post: 'liked your post',
            description:
                'Just had the best zoomies at the dog park! 🐕 Who else loves chasing squirrels?',
            profileImageUrl: 'assets/images/image.png',
            date: '2 hrs ago',
            numOfLikes: 142,
            imageUrl: 'assets/images/8ymcelbzhjqa1.jpg',
          ),
          const Divider(),
          // Real post from newsfeed - Princess Whiskers
          notif.CustomInformation(
            name: 'Princess Whiskers',
            post: 'commented on your photo',
            description:
                'My human thinks the laptop is for "work" but we all know it\'s actually a heated bed for cats. 🐱💅',
            profileImageUrl: 'assets/images/owl.jpg',
            date: '3 hrs ago',
            numOfLikes: 89,
            imageUrl:
                'assets/images/random-dog-i-found-on-a-hike-v0-5yza8uje7u2c1.jpg.webp',
          ),
          const Divider(),
          // Real post from newsfeed - Buddy the Beagle
          notif.CustomInformation(
            name: 'Buddy the Beagle',
            post: 'shared your post about treats',
            description:
                'SOMEONE LEFT THE TREAT JAR OPEN! This is not a drill! 🦴🎉',
            profileImageUrl: 'assets/images/manu_rios.jpg',
            date: '5 hrs ago',
            numOfLikes: 256,
            imageUrl: 'assets/images/owl.jpg',
          ),
          const Divider(),
          // NO IMAGE - shows person icon
          notif.CustomInformation(
            name: 'Anonymous User',
            post: 'started following you',
            description: 'A new follower wants to see your posts!',
            profileImageUrl: '', // Empty - will show person icon
            date: '6 hrs ago',
            numOfLikes: 0,
          ),
          const Divider(),
          // Real post from newsfeed - Sir Fluffington III
          notif.CustomInformation(
            name: 'Sir Fluffington III',
            post: 'reacted 🐾 to your story',
            description:
                'Grooming day was a disaster. They gave me a lion cut. A LION CUT. 😾',
            profileImageUrl: 'assets/images/image.png',
            date: '6 hrs ago',
            numOfLikes: 312,
            imageUrl: 'assets/images/images-7.jpeg',
          ),
          const Divider(),
          // NO IMAGE - shows person icon
          notif.CustomInformation(
            name: 'New Pet Parent',
            post: 'mentioned you in a comment',
            description: 'Thanks for the advice on pet food! 🐶',
            profileImageUrl: '', // Empty - will show person icon
            date: '8 hrs ago',
            numOfLikes: 5,
          ),
          const Divider(),
          // Real post from newsfeed - Luna the Labrador
          notif.CustomInformation(
            name: 'Luna the Labrador',
            post: 'invited you to the group',
            description:
                'Just learned that "bath time" and "beach time" are NOT the same thing. 🐶🛁',
            profileImageUrl: 'assets/images/image.png',
            date: 'Yesterday',
            numOfLikes: 178,
            imageUrl: 'assets/images/scale;webp=auto;jpeg_quality=60.jpg.webp',
          ),
          const Divider(),
          // Real post from newsfeed - Cheddar the Corgi
          notif.CustomInformation(
            name: 'Cheddar the Corgi',
            post: 'tagged you in a photo',
            description:
                'My legs may be short but my heart is full! Just got adopted today! 🧡🐾',
            profileImageUrl: 'assets/images/manu_rios.jpg',
            date: 'Yesterday',
            numOfLikes: 524,
            imageUrl: 'assets/images/images-8.jpeg',
          ),
          const Divider(),
          // NO IMAGE - shows person icon
          notif.CustomInformation(
            name: 'Guest Visitor',
            post: 'viewed your profile',
            description: 'Someone checked out your pawsome profile!',
            profileImageUrl: '', // Empty - will show person icon
            date: '2 days ago',
            numOfLikes: 0,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
