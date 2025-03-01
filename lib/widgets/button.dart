import 'package:flutter/material.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const Button({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.secondaryButtonText, // Optional secondary button text
    this.onSecondaryPressed, // Optional secondary button action
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonWidth = screenWidth * 0.8; // 80% of screen width
    double buttonHeight = screenHeight * 0.075; // 7.5% of screen height
    double fontSize = (buttonHeight * 0.5).clamp(14, 32);

    return Column(
      children: [
        /// Primary Button
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        /// Optional Secondary Button
        if (secondaryButtonText != null && onSecondaryPressed != null) ...[
          SizedBox(height: 10), // Small spacing
          TextButton(
            onPressed: onSecondaryPressed,
            child: Text(
              secondaryButtonText!,
              style: TextStyle(
                fontSize: 24, // Fixed 24px font size
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor, // No background, black text
              ),
            ),
          ),
        ],
      ],
    );
  }
}
