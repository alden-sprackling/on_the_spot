import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/header.dart';
import 'package:on_the_spot/widgets/info_icon_button.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import 'template_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);

    return TemplateScreen(
      leading: null,
      actions: [
        InfoIconButton(),
      ],
      messageBanners: messageProvider.messageBanners,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: Header(text: "Welcome!"),
        ),
        Expanded(
          flex: 2,
          child: InputField(
            controller: _controller,
            hintText: "Enter phone #",
            labelText: "Enter your phone number to get started:",
            keyboardType: TextInputType.phone,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              try {
                Navigator.pushNamed(context, '/auth'); // Navigate to the next screen
              } catch (e) {
                messageProvider.showMessage("$e", MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}