import 'package:flutter/material.dart';

class CustomFont extends StatelessWidget {
  const CustomFont({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.color,
    this.fontFamily = 'Frutiger',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.letterSpacing = 0,
    this.fontStyle = FontStyle.normal,
  });

  final String text;
  final double fontSize, letterSpacing;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  final FontStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color effectiveColor = color ?? (isDark ? Colors.white : const Color(0xFF1E293B));

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: effectiveColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
      ),
    );
  }
}