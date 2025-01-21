import 'package:flutter/material.dart';
import '../theme.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Future<void> Function()? onPressed;

  const BottomButton({
    super.key,
    required this.text,
    required this.color,
    this.borderColor = Colors.transparent,
    required this.onPressed,
    CircularProgressIndicator? child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color == Colors.white ? green : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        side: BorderSide(color: borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: bold16.copyWith(
            color: color == Colors.black ? green : Colors.black),
      ),
    );
  }
}
