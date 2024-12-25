// lib/widgets/rounded_button.dart

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double borderRadius;
  final TextStyle? textStyle;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.borderRadius = 30.0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
