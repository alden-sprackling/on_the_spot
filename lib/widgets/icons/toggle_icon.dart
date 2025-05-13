import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(
        isPublic ? 'PUBLIC' : 'PRIVATE',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}