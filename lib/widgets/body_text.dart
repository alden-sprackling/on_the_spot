import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyText extends StatelessWidget {
  final String text;
  final Color color;

  const BodyText({
    required this.text,
    this.color = Colors.black, // Default to black
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.grandstander(
        fontSize: 24, // Fixed at 24px
        fontWeight: FontWeight.w500, // Medium weight
        color: color,
      ),
      textAlign: TextAlign.left,
    );
  }
}
