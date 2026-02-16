import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/notification_screen.dart';
import '../widgets/custom_font.dart';
import '../screens/profile_screen.dart';
import '../services/user_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final UserDatabase _userDatabase = UserDatabase();
  String _userDisplayName = 'Profile'; // Default fallback
  bool _isLoadingUser = true;

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
              _userDisplayName = '$firstName $lastName'.trim();
            } else {
              _userDisplayName = username;
            }
            _isLoadingUser = false;
          });
          return;
        }
      }
      // If no user found, keep default
      setState(() {
        _isLoadingUser = false;
      });
    } catch (e) {
      // On error, keep default
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_TEXT_COLOR_WHITE,
      appBar: AppBar(
        backgroundColor: FB_TEXT_COLOR_WHITE,
        surfaceTintColor: Colors.transparent,
        shadowColor: FB_PRIMARY.withOpacity(0.1),
        elevation: 1,
        title: Row(
          children: [
            Icon(
              Icons.pets,
              color: FB_PRIMARY,
              size: ScreenUtil().setSp(28),
            ),
            SizedBox(width: ScreenUtil().setWidth(8)),
            CustomFont(
              text: _selectedIndex == 0
                  ? 'Pawbook'
                  : _selectedIndex == 1
                      ? 'Notifications'
                      : (_isLoadingUser ? 'Profile' : _userDisplayName),
              fontSize: ScreenUtil().setSp(24),
              color: FB_DARK_PRIMARY,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          NewsfeedScreen(),
          NotificationScreen(),
          ProfileScreen(), 
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: FB_TEXT_COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              color: FB_PRIMARY.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: FB_TEXT_COLOR_WHITE,
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
          unselectedItemColor: FB_TEXT_COLOR_GREY,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
