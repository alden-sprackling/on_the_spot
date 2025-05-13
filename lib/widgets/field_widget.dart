import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;

  const FieldWidget({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor = Colors.white, // Almost white color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24.0),
          Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          )
        ],
      ),
    );
  }
}