import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.lightGrey,
          size: 48.0, // Set the size of icons in the AppBar
        ),
      ),
      iconTheme: IconThemeData(
        size: 48.0, // Set the size of all icons
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.grandstanderTextTheme(),
    );
  }
}