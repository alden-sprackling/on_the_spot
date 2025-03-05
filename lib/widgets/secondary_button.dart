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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double buttonWidth = constraints.maxWidth; // Width based on parent widget
        double buttonHeight = buttonWidth * 0.2; // Height is 1/5 of the width
        double fontSize = (buttonHeight * 0.5).clamp(16, 32);

        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor, // No background, secondary color text
              ),
            ),
          ),
        );
      },
    );
  }
}