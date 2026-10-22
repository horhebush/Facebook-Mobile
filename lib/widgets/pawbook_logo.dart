import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

/// On-brand Pawbook logo: paw icon + wordmark.
/// Use [size] to scale for splash (large) vs header (small).
class PawbookLogo extends StatelessWidget {
  const PawbookLogo({
    super.key,
    this.size = PawbookLogoSize.medium,
    this.showTagline = false,
  });

  final PawbookLogoSize size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size == PawbookLogoSize.large
        ? ScreenUtil().setSp(80)
        : size == PawbookLogoSize.medium
        ? ScreenUtil().setSp(48)
        : ScreenUtil().setSp(28);
    final double fontSize = size == PawbookLogoSize.large
        ? ScreenUtil().setSp(40)
        : size == PawbookLogoSize.medium
        ? ScreenUtil().setSp(24)
        : ScreenUtil().setSp(16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: iconSize, color: FB_PRIMARY),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Text(
              APP_NAME,
              style: TextStyle(
                fontFamily: 'Klavika',
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: brandColor(context),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: ScreenUtil().setHeight(6)),
          Text(
            'Where pets connect! 🐾',
            style: TextStyle(
              fontFamily: 'Frutiger',
              fontSize: size == PawbookLogoSize.large
                  ? ScreenUtil().setSp(14)
                  : ScreenUtil().setSp(12),
              color: FB_TEXT_COLOR_GREY,
            ),
          ),
        ],
      ],
    );
  }
}

enum PawbookLogoSize { small, medium, large }
