// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InkDateElevatedButton extends StatelessWidget {
  InkDateElevatedButton({
    Key? key,
    this.isNegative = false,
    required this.text,
    this.textColor = Colors.white,
    required this.onTap,
    this.backgroundColor = AppColors.beige,
  }) : super(key: key);

  Color backgroundColor;
  final bool isNegative;
  final String text;
  Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: isNegative ? AppColors.darkGreen : backgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
