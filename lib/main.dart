import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/screens/home_screen.dart';
import '/screens/newsfeed_screen.dart';
import '/screens/notification_screen.dart';
import './screens/profile_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/splash_screen.dart';
import './services/user_database.dart';

void main() => runApp(const FuertesFacebook());

class FuertesFacebook extends StatefulWidget {
  const FuertesFacebook({super.key});

  @override
  State<FuertesFacebook> createState() => _FuertesFacebookState();
}

class _FuertesFacebookState extends State<FuertesFacebook> {
  final UserDatabase _userDatabase = UserDatabase();

  @override
  void initState() {
    super.initState();
    _initializeDefaultAccount();
  }

  Future<void> _initializeDefaultAccount() async {
    try {
      // Check if default account exists
      final existingUser = await _userDatabase.findUserByUsername('horhebush');
      
      if (existingUser == null) {
        // Create default account if it doesn't exist
        await _userDatabase.saveUser(
          firstName: 'Demi',
          lastName: '',
          mobileNumber: '12345678901',
          username: 'horhebush',
          password: 'Pawdel00\$',
        );
      }
    } catch (e) {
      // Silently handle initialization errors - app can still run
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/newsfeed': (context) => const NewsfeedScreen(),
            '/home': (context) => const HomeScreen(),
            '/notification': (context) => NotificationScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
        );
      },
    );
  }
}
