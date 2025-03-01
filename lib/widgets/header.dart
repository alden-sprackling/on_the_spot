import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String text;
  final String? subtext; // Optional subtext
  final Color color;

  const Header({
    required this.text,
    this.subtext, // Nullable subtext
    this.color = Colors.black, // Default to black
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: GoogleFonts.grandstander(
            fontSize: 64, // Fixed at 64px
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtext != null && subtext!.isNotEmpty) ...[
          SizedBox(height: 24), // Space between header and subtext
          Padding(
            padding: const EdgeInsets.only(right: 48, bottom: 24, left: 48),
            child: Text(
              subtext!,
              style: GoogleFonts.grandstander(
                fontSize: 24, // Subtext at 24px
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ],
    );
  }
}