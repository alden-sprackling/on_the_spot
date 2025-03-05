import 'package:flutter/material.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../providers/player_provider.dart'; // Import PlayerProvider
import 'base_screen.dart';
import '../utils/username_formatter.dart'; // Import the formatter

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  NameScreenState createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    return BaseScreen(
      leading: BackButton(),
      actions: null,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _controller,
            labelText: "How do you want to be seen by other players?",
            hintText: "Enter nickname",
            keyboardType: TextInputType.text,
            inputFormatters: [UsernameFormatter()], // Apply the formatter
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              final username = _controller.text;

              try {
                playerProvider.setPlayerName(username);
                FocusScope.of(context).requestFocus(FocusNode()); // Forces keyboard to close
                Navigator.pushNamed(context, '/home'); // Navigate to the next screen
              } catch (e) {
                messageProvider.showMessage(e.toString(), MessageType.error, showForLimitedTime: true);
              }
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}