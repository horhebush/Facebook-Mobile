import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_dialogs.dart';
import '../services/user_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserDatabase _userDatabase = UserDatabase();
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final username = usernameController.text.trim();
      final password = passwordController.text;

      final isValid = await _userDatabase.validateCredentials(
        username: username,
        password: password,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (isValid) {
        await _userDatabase.setCurrentUser(username);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        customDialog(
          context,
          title: 'Error',
          content: 'Username and password do not match.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      customDialog(
        context,
        title: 'Error',
        content: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Clear error message when user types
    usernameController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
    passwordController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_TEXT_COLOR_WHITE,
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [FB_PRIMARY, FB_SECONARY],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Welcome to Pawbook',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column(
                    children: [
                      // Pawbook Logo/Branding
                      Column(
                        children: [
                          Icon(
                            Icons.pets,
                            size: ScreenUtil().setSp(80),
                            color: FB_PRIMARY,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                            'Pawbook',
                            style: TextStyle(
                              fontFamily: 'Klavika',
                              fontSize: ScreenUtil().setSp(40),
                              fontWeight: FontWeight.bold,
                              color: FB_DARK_PRIMARY,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),
                          Text(
                            'Where pets connect! 🐾',
                            style: TextStyle(
                              fontFamily: 'Frutiger',
                              fontSize: ScreenUtil().setSp(14),
                              color: FB_TEXT_COLOR_GREY,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: usernameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your username' : null,
                        onSaved: (value) =>
                            usernameController.text = value ?? '',
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: FB_TEXT_COLOR_DARKGREY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Username',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: passwordController,
                        isObscure: _obscurePassword,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) =>
                            passwordController.text = value ?? '',
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: FB_TEXT_COLOR_DARKGREY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: FB_PRIMARY,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(15),
                            vertical: ScreenUtil().setHeight(10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: ScreenUtil().setSp(20),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10)),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      CustomInkwellButton(
                        onTap: _isLoading ? () {} : login,
                        height: ScreenUtil().setHeight(40),
                        width: ScreenUtil().screenWidth,
                        buttonName: _isLoading ? 'Logging in...' : 'Login',
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [FB_PRIMARY.withOpacity(0.9), FB_SECONARY],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to the pack? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Join Pawbook! 🐕',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}