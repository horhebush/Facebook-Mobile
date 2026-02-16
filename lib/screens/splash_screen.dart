import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/pawbook_logo.dart';
import '../widgets/pawbook_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.popAndPushNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        height: ScreenUtil().screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PawbookLogo(size: PawbookLogoSize.large, showTagline: true),
            SizedBox(height: ScreenUtil().setHeight(120)),
            PawbookLoading(),
          ],
        ),
      ),
    );
  }
}
