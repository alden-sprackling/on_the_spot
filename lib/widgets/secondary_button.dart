import 'package:flutter/material.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24, // Fixed 24px font size
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor, // No background, black text
        ),
      ),
    );
  }
}