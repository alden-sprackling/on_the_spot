import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/icons/settings_icon_button.dart';
import '../widgets/user_widget.dart';
import '../widgets/buttons/button.dart';
import '/theme/app_colors.dart';
import 'base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      resizeToAvoidBottomInset: false, // Prevents screen from resizing when keyboard appears
      leading: null,
      actions: [
        SettingsIconButton(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      columnWidgets: [
        UserWidget(
          containerWidthPercent: .75, // Adjust width to 75% of the screen
        ),
        Column(
          children: [
            Button(
              text: "JOIN GAME",
              onPressed: () {
                try {
                  Navigator.pushNamed(context, '/join_game'); // Navigate to the next screen
                } catch (e) {
                }
              },
              backgroundColor: AppColors.primaryColor,
            ),
            SizedBox(height: 24),
            Button(
              text: "CREATE GAME",
              onPressed: () {
                try {
                  Navigator.pushNamed(context, '/create_game'); // Navigate to the next screen
                } catch (e) {
                }
              },
              backgroundColor: AppColors.secondaryColor,
            ),
          ],
        ),
      ],
    );
  }
}