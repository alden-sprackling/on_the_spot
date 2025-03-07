import 'package:flutter/material.dart';
import '../widgets/back_icon_button.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '../theme/app_colors.dart';
import 'base_screen.dart';

class JoinGameScreen extends StatelessWidget {
  JoinGameScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: BackIconButton(),
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _controller,
            hintText: "Enter game code",
            keyboardType: TextInputType.number,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              // Navigator.pushNamed(context, '/create_game'); // Navigate to the next screen
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}