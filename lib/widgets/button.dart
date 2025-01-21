import 'package:flutter/material.dart';
import '../theme.dart';

class Button extends StatelessWidget {
  final String text;
  final Color color;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback onPressed; // Accepts a function for button presses

  const Button({
    super.key,
    required this.text,
    required this.color,
    this.borderColor,
    this.textColor,
    required this.onPressed, // Makes the `onPressed` parameter required
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenWidth * 0.02;

    return ElevatedButton(
      onPressed: onPressed, // Use the passed `onPressed` callback
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color == Colors.white ? white : Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        minimumSize: const Size(0, 36),
        side: BorderSide(color: borderColor ?? Colors.transparent, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: bold14.copyWith(
          color: textColor ?? (color == Colors.white ? black : Colors.white),
        ),
      ),
    );
  }
}
