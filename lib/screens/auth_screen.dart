import 'package:flutter/material.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '/providers/app_state.dart';
import 'template_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return TemplateScreen(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back),
      ),
      actions: null,
      messageBanners: appState.messageBanners,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _controller,
            hintText: "Enter code",
            labelText: "Enter the code that was sent through text:",
            keyboardType: TextInputType.number,
          ),
        ),
        Expanded(
          flex: 1,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              try {
                Navigator.pushNamed(context, '/appearance'); // Navigate to the next screen
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