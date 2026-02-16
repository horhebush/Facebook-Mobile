import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = FB_TEXT_COLOR_WHITE,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.suffixIcon,
  });

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool isObscure;
  final double fontSize;
  final Color? fontColor;
  final double height;
  final double width;
  final double hintTextSize;
  final String hintText;
  final Color fillColor;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(
        fontSize: fontSize, 
        color: fontColor ?? FB_TEXT_COLOR_DARKGREY,
        fontFamily: 'Frutiger',
      ),
      cursorColor: FB_PRIMARY,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(width, height, width, height),
        focusColor: FB_PRIMARY,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: FB_LIGHT_PRIMARY, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: FB_ERROR, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        errorStyle: TextStyle(fontFamily: 'Frutiger', color: FB_ERROR),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: FB_ERROR, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: FB_PRIMARY, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: FB_TEXT_COLOR_GREY,
          fontSize: hintTextSize,
          fontFamily: 'Frutiger',
        ),
        hintText: hintText,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
      ),
    );
  }
}