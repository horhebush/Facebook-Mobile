import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../services/user_service.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';

// ENHANCEMENT 1: sign-in form that authenticates against the API.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Prefilled with a working account, since the API only knows its own users.
  final usernameController = TextEditingController(text: 'emilys');
  final passwordController = TextEditingController(text: 'emilyspass');
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Sends the credentials to the API; the service saves the user on success.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await UserService().loginUser(
        usernameController.text.trim(),
        passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      customDialog(
        context,
        title: 'Login failed',
        content: '$e'.replaceFirst('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight - padding.top - padding.bottom,
            width: ScreenUtil().screenWidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _banner('Welcome to Pawbook'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 80.sp, color: FB_PRIMARY),
                        SizedBox(height: 10.h),
                        Text(
                          'Pawbook',
                          style: TextStyle(
                            fontFamily: 'Klavika',
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            color: brandColor(context),
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Where pets connect! 🐾',
                          style: TextStyle(
                            fontFamily: 'Frutiger',
                            fontSize: 14.sp,
                            color: FB_TEXT_COLOR_GREY,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomTextFormField(
                          height: 10.h,
                          width: 10.w,
                          controller: usernameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your username' : null,
                          onSaved: (value) =>
                              usernameController.text = value ?? '',
                          fontSize: 15.sp,
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: 15.sp,
                          hintText: 'Username',
                        ),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          height: 10.h,
                          width: 10.w,
                          controller: passwordController,
                          isObscure: _obscurePassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your password' : null,
                          onSaved: (value) =>
                              passwordController.text = value ?? '',
                          fontSize: 15.sp,
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: 15.sp,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: FB_PRIMARY,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        CustomInkwellButton(
                          onTap: _isLoading ? () {} : _login,
                          height: 40.h,
                          width: ScreenUtil().screenWidth,
                          buttonName: _isLoading ? 'Signing in...' : 'Sign In',
                          fontSize: 15.sp,
                        ),
                      ],
                    ),
                  ),
                  _banner('Sign in with a dummyJSON account 🐕'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The gradient strip at the top and bottom of the form.
  Widget _banner(String text) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 50.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [FB_PRIMARY, FB_SECONARY],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
