import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_font.dart';

class CustomButton extends StatefulWidget {
  final String buttonType;
  final String buttonName;
  final Color? fontColor;
  final Color? outlineColor;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.buttonType = 'elevated',
    required this.buttonName,
    this.fontColor,
    required this.onPressed,
    this.outlineColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultFontColor = isDark ? Colors.white : Colors.black;
    final effectiveFontColor = widget.fontColor ?? defaultFontColor;
    final effectiveOutlineColor = widget.outlineColor ?? (isDark ? Colors.grey[500]! : Colors.black);

    final type = widget.buttonType.toLowerCase();
    if (type == 'outlined') {
      return OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: effectiveOutlineColor),
        ),
        child: CustomFont(
          text: widget.buttonName,
          fontSize: ScreenUtil().setSp(15),
          color: effectiveFontColor,
        ),
      );
    } else if (type == 'text') {
      return TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: widget.buttonName,
          fontSize: ScreenUtil().setSp(12),
          color: effectiveFontColor,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
          foregroundColor: effectiveFontColor,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: widget.buttonName,
          fontSize: ScreenUtil().setSp(12),
          color: effectiveFontColor,
        ),
      );
    }
  }
}
