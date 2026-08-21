import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
