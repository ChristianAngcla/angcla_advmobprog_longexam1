import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';

class CustomInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CustomInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ScreenUtil().setSp(22),
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFont(
                  text: title,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.bold,
                ),
                CustomFont(
                  text: subtitle,
                  fontSize: ScreenUtil().setSp(13),
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
