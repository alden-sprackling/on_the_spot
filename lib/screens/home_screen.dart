import 'package:flutter/material.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '/providers/app_state.dart';
import 'template_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return TemplateScreen(
      leading: null,
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
        // Add functionality here
          },
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: () {
        // Add functionality here
          },
        ),
      ],
      messageBanners: appState.messageBanners,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: Button(
            text: "HOST",
            onPressed: () {
              try {
              } catch (e) {
                appState.showMessage("$e", MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.secondaryColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: Button(
            text: "JOIN",
            onPressed: () {
              try {
              } catch (e) {
                appState.showMessage("$e", MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}