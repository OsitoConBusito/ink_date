import 'package:flutter/material.dart';

class InkDateTextButton extends StatelessWidget {
  const InkDateTextButton({
    Key? key,
    required this.text,
    this.isBold = false,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final bool isBold;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
