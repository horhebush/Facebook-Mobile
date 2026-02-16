import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_dialogs.dart';
import '../services/user_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserDatabase _userDatabase = UserDatabase();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Validate first name
  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'Please enter your first name.',
      );
      return 'First name is required';
    }
    final firstName = value.trim();
    if (firstName.length < 2) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'First name must be at least 2 characters long.',
      );
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(firstName)) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'First name can only contain letters and spaces.',
      );
      return 'First name can only contain letters';
    }
    return null;
  }

  // Validate last name
  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Please enter your last name.',
      );
      return 'Last name is required';
    }
    final lastName = value.trim();
    if (lastName.length < 2) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Last name must be at least 2 characters long.',
      );
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(lastName)) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Last name can only contain letters and spaces.',
      );
      return 'Last name can only contain letters';
    }
    return null;
  }

  // Validate mobile number
  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Please enter your mobile number.',
      );
      return 'Mobile number is required';
    }
    final mobileNumber = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (mobileNumber.length != 11) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number must be exactly 11 digits.',
      );
      return 'Mobile number must be exactly 11 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(mobileNumber)) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number can only contain numbers.',
      );
      return 'Mobile number can only contain numbers';
    }
    return null;
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Please enter a username.',
      );
      return 'Username is required';
    }
    final username = value.trim();
    if (username.length < 3) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Username must be at least 3 characters long.',
      );
      return 'Username must be at least 3 characters';
    }
    if (username.length > 20) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Username must not exceed 20 characters.',
      );
      return 'Username must not exceed 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Username can only contain letters, numbers, and underscores.',
      );
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Please enter a password.',
      );
      return 'Password is required';
    }
    if (value.length < 8) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must be at least 8 characters long.',
      );
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one uppercase letter.',
      );
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one lowercase letter.',
      );
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one number.',
      );
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one special character (!@#\$%^&*(),.?":{}|<>).',
      );
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      customDialog(
        context,
        title: 'Password Mismatch',
        content: 'Please confirm your password.',
      );
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      customDialog(
        context,
        title: 'Password Mismatch',
        content: 'Passwords do not match. Please try again.',
      );
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> register() async {
    // Validate all fields
    final firstNameError = _validateFirstName(firstNameController.text);
    if (firstNameError != null) return;

    final lastNameError = _validateLastName(lastNameController.text);
    if (lastNameError != null) return;

    final mobileNumberError = _validateMobileNumber(mobileNumberController.text);
    if (mobileNumberError != null) return;

    final usernameError = _validateUsername(usernameController.text);
    if (usernameError != null) return;

    final passwordError = _validatePassword(passwordController.text);
    if (passwordError != null) return;

    final confirmPasswordError = _validateConfirmPassword(confirmPasswordController.text);
    if (confirmPasswordError != null) return;

    try {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final mobileNumber = mobileNumberController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // Check if username already exists
      final existingUser = await _userDatabase.findUserByUsername(username);
      if (existingUser != null) {
        if (!mounted) return;
        customDialog(
          context,
          title: 'Registration Failed',
          content: 'Username already exists. Please choose a different username.',
        );
        return;
      }

      // Save user to database
      final error = await _userDatabase.saveUser(
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        username: username,
        password: password,
      );

      if (!mounted) return;

      if (error != null) {
        customDialog(
          context,
          title: 'Registration Failed',
          content: error,
        );
      } else {
        // Registration successful
        customDialog(
          context,
          title: 'Registration Successful',
          content: 'Your account has been created successfully! Welcome to Pawbook! 🐾',
        );
        
        // Navigate to login screen after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        customDialog(
          context,
          title: 'Registration Error',
          content: 'An error occurred while registering: ${e.toString()}',
        );
      }
    }
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
                          'Join Pawbook',
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(25),
                      vertical: ScreenUtil().setHeight(20),
                    ),
                    child: Column(
                      children: [
                        // Pawbook Logo/Branding
                        Column(
                          children: [
                            Icon(
                              Icons.pets,
                              size: ScreenUtil().setSp(60),
                              color: FB_PRIMARY,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Klavika',
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.bold,
                                color: FB_DARK_PRIMARY,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(5)),
                            Text(
                              'Join the pack! 🐾',
                              style: TextStyle(
                                fontFamily: 'Frutiger',
                                fontSize: ScreenUtil().setSp(14),
                                color: FB_TEXT_COLOR_GREY,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        // First Name
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: firstNameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your first name' : null,
                          onSaved: (value) =>
                              firstNameController.text = value ?? '',
                          fontSize: ScreenUtil().setSp(15),
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: ScreenUtil().setSp(15),
                          hintText: 'First Name',
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        // Last Name
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: lastNameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your last name' : null,
                          onSaved: (value) =>
                              lastNameController.text = value ?? '',
                          fontSize: ScreenUtil().setSp(15),
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: ScreenUtil().setSp(15),
                          hintText: 'Last Name',
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        // Mobile Number
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: mobileNumberController,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your mobile number' : null,
                          onSaved: (value) =>
                              mobileNumberController.text = value ?? '',
                          fontSize: ScreenUtil().setSp(15),
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: ScreenUtil().setSp(15),
                          hintText: 'Mobile Number',
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        // Username
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: usernameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a username' : null,
                          onSaved: (value) =>
                              usernameController.text = value ?? '',
                          fontSize: ScreenUtil().setSp(15),
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: ScreenUtil().setSp(15),
                          hintText: 'Username',
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        // Password
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: passwordController,
                          isObscure: _obscurePassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a password' : null,
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
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        // Confirm Password
                        CustomTextFormField(
                          height: ScreenUtil().setHeight(10),
                          width: ScreenUtil().setWidth(10),
                          controller: confirmPasswordController,
                          isObscure: _obscureConfirmPassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Confirm your password' : null,
                          onSaved: (value) =>
                              confirmPasswordController.text = value ?? '',
                          fontSize: ScreenUtil().setSp(15),
                          fontColor: FB_TEXT_COLOR_DARKGREY,
                          hintTextSize: ScreenUtil().setSp(15),
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: FB_PRIMARY,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        CustomInkwellButton(
                          onTap: () async => await register(),
                          height: ScreenUtil().setHeight(40),
                          width: ScreenUtil().screenWidth,
                          buttonName: 'Register',
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ],
                    ),
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
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          'Login! 🐕',
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
