import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final Color? color;

  const LoadingOverlay({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  /// Static method to show the loading overlay
  static void show(BuildContext context, {Color? color}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (BuildContext dialogContext) {
        return LoadingOverlay(color: color);
      },
    );
  }

  /// Static method to hide the loading overlay
  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Close the dialog
    }
  }
}