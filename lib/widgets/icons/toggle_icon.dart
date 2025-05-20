import 'package:flutter/material.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class ToggleIcon extends StatelessWidget {
  final bool isPublic;
  final VoidCallback? onPressed;

  const ToggleIcon({
    super.key,
    required this.isPublic,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPublic ? AppColors.lightGrey : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        isPublic ? 'PUBLIC' : 'PRIVATE',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isPublic ? Colors.white : AppColors.lightGrey,
        ),
      ),
    );
  }
}