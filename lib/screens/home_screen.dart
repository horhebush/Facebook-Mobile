import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/pawbook_loading.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

// Shell with the bottom bar; holds the three tabs and the signed-in user.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Reads the user the splash screen confirmed is saved.
  Future<void> _loadUser() async {
    final user = await UserService().getUser();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = _user;

    if (user == null) {
      return const Scaffold(body: Center(child: PawbookLoading()));
    }

    final titles = ['Pawbook', 'Notifications', user.fullName];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: FB_PRIMARY.withValues(alpha: 0.1),
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.pets, color: FB_PRIMARY, size: 28.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomFont(
                text: titles[_selectedIndex],
                fontSize: 24.sp,
                color: brandColor(context),
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // ENHANCEMENT 2: the settings screen.
          IconButton(
            icon: Icon(Icons.settings_outlined, color: brandColor(context)),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _selectedIndex = page),
        children: [
          const NewsfeedScreen(),
          NotificationScreen(user: user),
          ProfileScreen(user: user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: scheme.surface,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Profile',
          ),
        ],
        selectedItemColor: FB_PRIMARY,
        unselectedItemColor: scheme.onSurfaceVariant,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Switches the page when a bottom bar item is tapped.
  void _onTappedBar(int value) {
    setState(() => _selectedIndex = value);
    _pageController.jumpToPage(value);
  }
}
