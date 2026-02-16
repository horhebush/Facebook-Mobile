import 'package:flutter/material.dart';
import '../constants.dart';

class CustomInkwellButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final String buttonName;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool useGradient;

  const CustomInkwellButton({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    required this.buttonName,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: useGradient && backgroundColor == null
                ? LinearGradient(
                    colors: [FB_PRIMARY, FB_SECONARY],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: !useGradient || backgroundColor != null 
                ? (backgroundColor ?? FB_PRIMARY) 
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: FB_PRIMARY.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: 'Frutiger',
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Keep the original CommentButton for backwards compatibility
class CommentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final Color textColor;

  const CommentButton({
    super.key,
    required this.onPressed,
    this.iconSize = 20,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/icons/comment.png',
        width: iconSize,
        height: iconSize,
      ),
      label: Text(
        'Comment',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
