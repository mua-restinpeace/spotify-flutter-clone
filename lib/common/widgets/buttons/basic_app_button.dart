import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? height;
  const BasicAppButton(
      {required this.onPressed, required this.text, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: Size.fromHeight(height ?? 92),
      ),
      child: Text(text),
    );
  }
}
