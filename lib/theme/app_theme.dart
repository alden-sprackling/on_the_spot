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
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.chewyTextTheme(),
    );
  }
}