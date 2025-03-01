import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType; // New parameter for keyboard type

  const InputField({
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text, // Default to text keyboard
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double inputWidth = screenWidth * 0.8; // 80% of screen width
    double inputHeight = screenHeight * 0.075; // 7.5% of screen height
    double fontSize = (inputHeight * 0.5).clamp(14, 32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (labelText != null && labelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 48, bottom: 24, left: 48),
            child: Text(
              labelText!,
              style: GoogleFonts.grandstander(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        SizedBox(
          width: inputWidth,
          height: inputHeight,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType, // Sets the keyboard type
            autofocus: true, // Auto-focus enabled
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: fontSize,
                color: AppColors.hintTextColor,
              ),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

