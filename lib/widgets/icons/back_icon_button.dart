import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  final VoidCallback? extraOnPressed;

  const BackIconButton({super.key, this.extraOnPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () {
        if (extraOnPressed != null) {
          extraOnPressed!();
        }
        Navigator.pop(context);
      },
    );
  }
}