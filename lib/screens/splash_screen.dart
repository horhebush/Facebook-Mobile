import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import '../widgets/pawbook_loading.dart';
import '../widgets/pawbook_logo.dart';

// ENHANCEMENT 1: first screen. Reads the saved session and decides where to start.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Goes to the feed if a token is on the device, otherwise to sign-in.
  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await UserService().isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, loggedIn ? '/home' : '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PawbookLogo(size: PawbookLogoSize.large, showTagline: true),
            SizedBox(height: 120.h),
            const PawbookLoading(),
          ],
        ),
      ),
    );
  }
}
