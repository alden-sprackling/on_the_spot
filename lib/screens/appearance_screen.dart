import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/header.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '/providers/app_state.dart';
import 'template_screen.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  AppearanceScreenState createState() => AppearanceScreenState();
}

class AppearanceScreenState extends State<AppearanceScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return TemplateScreen(
      leading: null,
      actions: null,
      messageBanners: appState.messageBanners,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: Header(
            text: "Appearance", 
          ),
        ),
        Expanded(
          flex: 1,
          child: InputField(
            controller: _controller,
            hintText: "Enter nickname",
            keyboardType: TextInputType.text,
            centerText: true,
          ),
        ),
        Expanded(
          flex: 1,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              try {
                Navigator.pushNamed(context, '/home'); // Navigate to the next screen
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