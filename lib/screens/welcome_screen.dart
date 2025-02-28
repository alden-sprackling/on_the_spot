import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/header.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures taps on empty space register
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // Forces keyboard to close
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Header at the top
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Header(text: "Welcome!"),
              ),
            ),

            /// Input field positioned 2/3 down
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: InputField(
                  controller: _controller,
                  hintText: "Enter phone #",
                  labelText: "Enter your phone number to get started:",
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),

            /// Button positioned at the bottom
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: Button(
                  text: "Continue >",
                  onPressed: () {},
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
