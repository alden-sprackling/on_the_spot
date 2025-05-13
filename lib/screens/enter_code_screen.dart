import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';
import '../utils/formatters.dart';
import '../widgets/icons/back_icon_button.dart';
import '../widgets/input_fields/input_field.dart';
import '../widgets/buttons/button.dart';
import '/theme/app_colors.dart';
import 'base_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  final String phoneNumber;

  const EnterCodeScreen({super.key, required this.phoneNumber});

  @override
  EnterCodeScreenState createState() => EnterCodeScreenState();
}

class EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final maxCodeLength = AuthCodeFormatter().maxLength;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _verifyCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    try {
      // Verify the SMS code
      await authProvider.verifyCode(widget.phoneNumber, _codeController.text.trim());

      // Navigate to the next screen or perform post-verification actions
      if (!mounted) return;
      messageProvider.addMessage(
        Message(
          content: "Code verified successfully!",
          type: MessageType.success,
        ),
      );

      if (authProvider.user?.name == null) {
        // If the user is not authenticated, navigate to the next screen
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/set_name',
          (Route<dynamic> route) => false,
        );
      } else if (authProvider.user?.profilePic == null) {
        // If the user has not set a profile picture, navigate to the next screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/set_profile_picture',
          (Route<dynamic> route) => false,
        );
      } else {
        // If the user is already authenticated, navigate to the home screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );

      }
    } catch (e) {
      // Show error message if verification fails
      messageProvider.addMessage(
        Message(
          content: e.toString(),
          type: MessageType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: BackIconButton(),
      actions: null,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _codeController,
            hintText: "Enter code",
            labelText: "Enter the code that was sent through text:",
            keyboardType: TextInputType.number,
            inputFormatters: [AuthCodeFormatter()],
            maxLength: maxCodeLength,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "VERIFY CODE >",
            onPressed: _verifyCode, // Manual verification if the user presses the button
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose(); // Clean up the controller
    super.dispose();
  }
}