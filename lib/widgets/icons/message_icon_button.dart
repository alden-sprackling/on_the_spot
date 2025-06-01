import 'package:flutter/material.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class MessageIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const MessageIconButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.message_outlined,
        color: iconColor ?? AppColors.lightGrey,
        size: iconSize ?? 50.0,
      ),
      padding: padding ?? const EdgeInsets.all(8.0),
      onPressed: onPressed,
      tooltip: 'Message',
    );
  }
}