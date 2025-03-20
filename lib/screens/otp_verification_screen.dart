import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../services/auth_service.dart';
import '../widgets/back_icon_button.dart';
import '../widgets/loading_overlay.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'base_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  OTPVerificationScreenState createState() => OTPVerificationScreenState();
}

class OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  final AuthService _authService = AuthService(baseUrl: 'https://onthespotgame.com');

  Future<void> _verifyCodeAndNavigate(BuildContext context, MessageProvider messageProvider, String? phoneNumber) async {
    try {
      // Checks if the phone number was passed as an argument
      // If not, navigate back to the previous screen
      if (phoneNumber == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        throw ArgumentError("Phone number lost in navigation."); // Will change exceptions later
      }

      // Show the loading overlay
      LoadingOverlay.show(context);

      // Perform the async verification
      await _authService.verifyCode(phoneNumber, _controller.text);

      // Navigate to the next screen if the context is still valid
      if (context.mounted) {
        LoadingOverlay.hide(context); // Close the loading overlay
        Navigator.pushNamed(context, '/name');
      }
    } catch (e) {
      // Handle errors and show a message using the MessageProvider
      if (context.mounted) {
        LoadingOverlay.hide(context); // Close the loading overlay
        messageProvider.showMessage(
          e.toString(),
          MessageType.error,
          showForLimitedTime: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final phoneNumber = ModalRoute.of(context)?.settings.arguments as String?;

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
            controller: _controller,
            hintText: "Enter code",
            labelText: "Enter the code that was sent through text:",
            keyboardType: TextInputType.number,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () => _verifyCodeAndNavigate(context, messageProvider, phoneNumber),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}