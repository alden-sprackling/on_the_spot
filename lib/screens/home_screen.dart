import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/info_icon_button.dart';
import 'package:on_the_spot/widgets/settings_icon_button.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../widgets/player.dart';
import '/widgets/button.dart';
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
    final messageProvider = Provider.of<MessageProvider>(context);
    
    return BaseScreen(
      resizeToAvoidBottomInset: false, // Prevents screen from resizing when keyboard appears
      leading: BackButton(),
      actions: [
        InfoIconButton(),
        SettingsIconButton(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      columnWidgets: [
        Player(),
        Column(
          children: [
            Button(
              text: "JOIN",
              onPressed: () {
                try {
                  Navigator.pushNamed(context, '/join'); // Navigate to the next screen
                } catch (e) {
                  messageProvider.showMessage(e.toString(), MessageType.error, showForLimitedTime: true);
                }
              },
              backgroundColor: AppColors.primaryColor,
            ),
            SizedBox(height: 24),
            Button(
              text: "HOST",
              onPressed: () {
                try {
                  Navigator.pushNamed(context, '/host_lobby'); // Navigate to the next screen
                } catch (e) {
                  messageProvider.showMessage(e.toString(), MessageType.error, showForLimitedTime: true);
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