import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/info_icon_button.dart';
import 'package:on_the_spot/widgets/player.dart';
import 'package:on_the_spot/widgets/settings_icon_button.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import 'template_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);

    return TemplateScreen(
      leading: null,
      actions: [
        InfoIconButton(),
        SettingsIconButton(),
      ],
      messageBanners: messageProvider.messageBanners,
      columnWidgets: [
        Expanded(
          flex: 0,
          child: Player(),
        ),
        Expanded(
          flex: 1,
          child: SizedBox()),
        Expanded(
          flex: 0,
          child: Button(
            text: "JOIN",
            onPressed: () {
              try {
              } catch (e) {
                messageProvider.showMessage("$e", MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "HOST",
            onPressed: () {
              try {
              } catch (e) {
                messageProvider.showMessage("$e", MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }
}