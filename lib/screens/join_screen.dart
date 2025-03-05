import 'package:flutter/material.dart';

import '../widgets/back_icon_button.dart';
import 'base_screen.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: BackIconButton(),
      columnWidgets: [],
    );
  }
}
