import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    required this.controller,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    required this.height,
    required this.width,
    this.keyBoardType = TextInputType.text,
    this.maxLength = 200,
  });

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController controller;

  final bool isObscure;

  final double fontSize;
  final Color? fontColor;
  final double height, width;
  final double hintTextSize;
  final String hintText;
  final Color fillColor;
  final TextInputType keyBoardType;
  final int maxLength;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveFontColor = (isDark &&
            (widget.fontColor == null ||
                widget.fontColor == const Color(0xFF1E293B) ||
                widget.fontColor == Colors.black))
        ? Colors.white
        : (widget.fontColor ??
            (isDark ? Colors.white : const Color(0xFF1E293B)));
    final effectiveFillColor =
        isDark ? const Color(0xFF2A2A2A) : widget.fillColor;
    final effectiveHintColor = isDark ? Colors.grey[400] : Colors.black45;

    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      controller: widget.controller,
      obscureText: widget.isObscure ? _obscure : false,
      keyboardType: widget.keyBoardType,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
      style: TextStyle(fontSize: widget.fontSize, color: effectiveFontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          widget.width,
          widget.height,
          widget.width,
          widget.height,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: FB_DARK_PRIMARY, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: FB_LIGHT_PRIMARY, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: effectiveFillColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: effectiveHintColor,
          fontSize: widget.hintTextSize,
          fontFamily: 'Frutiger',
        ),

        /// 👁 PASSWORD TOGGLE ICON
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
