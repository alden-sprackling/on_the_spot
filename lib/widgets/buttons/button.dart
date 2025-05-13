import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor; // Optional text color

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor,
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
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}