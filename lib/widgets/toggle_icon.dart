import 'package:flutter/material.dart';
import '/theme/app_colors.dart';

class ToggleIcon extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const ToggleIcon({super.key, this.initialValue = false, this.onChanged});

  @override
  ToggleIconState createState() => ToggleIconState();
}

class ToggleIconState extends State<ToggleIcon> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      isToggled = !isToggled;
    });
    widget.onChanged?.call(isToggled);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Icon(
        isToggled ? Icons.toggle_on : Icons.toggle_off,
        color: isToggled ? AppColors.confirmationGreen : AppColors.lightGrey,
      ),
    );
  }
}
