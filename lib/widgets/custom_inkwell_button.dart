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
                color: FB_PRIMARY.withValues(alpha: 0.3),
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
