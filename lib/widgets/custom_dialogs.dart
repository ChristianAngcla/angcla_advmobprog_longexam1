import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import 'package:flutter/material.dart';

void customDialog(BuildContext context, {required title, required content}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Okay', style: TextStyle(fontWeight: FontWeight.bold)),
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
  required title,
  required content,
  required Function onYes,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: CustomFont(text: title, fontSize: 30.sp),
    content: CustomFont(text: content),
    actions: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: CustomFont(text: 'No'),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onYes();
        },
        child: CustomFont(
          text: 'Yes',
          color: FB_TEXT_COLOR_WHITE,
          fontWeight: FontWeight.bold,
        ),
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

void customShowImageDialog(BuildContext context, {required imageUrl}) {
  AlertDialog alertDialog = AlertDialog(
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: SizedBox(
      height: 300.h,
      width: 300.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            (imageUrl.startsWith('http'))
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            color: FB_DARK_PRIMARY,
                            value: downloadProgress.progress,
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.error, size: 100.sp)),
                  )
                : Image.asset(
                    imageUrl,
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Center(child: Icon(Icons.error, size: 100.sp)),
                  ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}
