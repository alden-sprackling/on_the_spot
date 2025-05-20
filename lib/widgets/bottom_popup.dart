import 'package:flutter/material.dart';

class BottomPopup extends StatelessWidget {
  final List<Widget> children;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const BottomPopup({
    super.key,
    required this.children,
    this.height,
    this.padding,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required List<Widget> children,
    double? height,
    EdgeInsetsGeometry? padding,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      builder: (context) => BottomPopup(
        height: height,
        padding: padding,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 50),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}