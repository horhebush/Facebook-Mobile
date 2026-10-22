import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import 'custom_font.dart';

void customDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  // Determine if it's an error or info dialog
  final bool isError =
      title.toLowerCase().contains('invalid') ||
      title.toLowerCase().contains('error') ||
      title.toLowerCase().contains('failed') ||
      title.toLowerCase().contains('mismatch');

  AlertDialog alertDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: FB_TEXT_COLOR_WHITE,
    title: Row(
      children: [
        Icon(
          isError ? Icons.warning_amber_rounded : Icons.pets,
          color: isError ? FB_ERROR : FB_PRIMARY,
          size: 28,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: FB_DARK_PRIMARY,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
    content: Text(
      content,
      style: TextStyle(color: FB_TEXT_COLOR_DARKGREY, fontSize: 15),
    ),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isError ? FB_DARK_PRIMARY : FB_PRIMARY,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(isError ? 'Got it!' : 'Pawsome! 🐾'),
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

void customOptionDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function onYes,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: CustomFont(text: title, fontSize: 30.sp, color: FB_DARK_PRIMARY),
    content: CustomFont(
      text: content,
      fontSize: 16.sp,
      color: FB_TEXT_COLOR_DARKGREY,
    ),
    actions: [
      OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const CustomFont(
          text: 'No',
          fontSize: 16,
          color: FB_DARK_PRIMARY,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: FB_DARK_PRIMARY,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onYes();
        },
        child: const CustomFont(
          text: 'Yes',
          fontSize: 16,
          color: FB_TEXT_COLOR_WHITE,
        ),
      ),
    ],
  );
  showDialog(context: context, builder: (BuildContext context) => alertDialog);
}

/// [imageUrl] can be a network URL (http/https) or an asset path (e.g. assets/images/...).
/// Network URLs use CachedNetworkImage; asset paths use Image.asset.
/// Dialog includes a close icon to exit.
void customShowImageDialog(BuildContext context, {required String imageUrl}) {
  final bool isNetworkUrl =
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  AlertDialog alertDialog = AlertDialog(
    backgroundColor: FB_TEXT_COLOR_WHITE,
    contentPadding: EdgeInsets.zero,
    content: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 300.h,
          padding: EdgeInsets.only(top: 40.h),
          child: Center(
            child: isNetworkUrl
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                              value: downloadProgress.progress,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                FB_DARK_PRIMARY,
                              ),
                            ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, size: 100.sp, color: FB_ERROR),
                  )
                : Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100.sp, color: FB_ERROR),
                  ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: FB_DARK_PRIMARY, size: 28.sp),
              style: IconButton.styleFrom(
                backgroundColor: FB_LIGHT_PRIMARY,
                padding: EdgeInsets.all(4.sp),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => alertDialog);
}
