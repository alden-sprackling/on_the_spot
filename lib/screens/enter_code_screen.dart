import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/system_message.dart';
import '../providers/auth_provider.dart';
import '../providers/system_message_provider.dart';
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

    // Add a listener to automatically verify the code when max length is reached
    _codeController.addListener(() {
      if (_codeController.text.length == maxCodeLength) {
        _verifyCode(); // Automatically verify the code
      }
    });
  }

  Future<void> _verifyCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final systemMessageProvider = Provider.of<SystemMessageProvider>(context, listen: false);

    try {
      // Verify the SMS code
      await authProvider.verifySMSCode(widget.phoneNumber, _codeController.text.trim());

      // Navigate to the next screen or perform post-verification actions
      if (!mounted) return;
      systemMessageProvider.addMessage(
        SystemMessage(
          content: "Code verified successfully!",
          type: SystemMessageType.success,
        ),
      );

      // Example: Navigate to a home screen or dashboard
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Show error message if verification fails
      systemMessageProvider.addMessage(
        SystemMessage(
          content: e.toString(),
          type: SystemMessageType.error,
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