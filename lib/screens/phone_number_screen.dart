import 'package:flutter/material.dart';
import 'package:on_the_spot/utils/phone_number_formatter.dart';
import 'package:on_the_spot/widgets/header_text.dart';
import 'package:on_the_spot/widgets/info_icon_button.dart';
import '../widgets/loading_overlay.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import 'base_screen.dart';
import '/services/auth_service.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  PhoneNumberScreenState createState() => PhoneNumberScreenState();
}

class PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthService _authService = AuthService(baseUrl: 'https://onthespotgame.com');

  Future<void> _sendCodeAndNavigate(BuildContext context, MessageProvider messageProvider) async {
    try {
      // Show the loading overlay
      LoadingOverlay.show(context);

      // Perform the async operation and get the confirmation message
      // If the phone number is invalid, the AuthService will throw an error
      final confirmationMessage = await _authService.sendVerificationCode(_phoneNumberController.text);

      // Navigate to the next screen if the context is still valid
      if (context.mounted) {
        LoadingOverlay.hide(context); // Close the loading overlay

        // Show the confirmation message using the MessageProvider
        messageProvider.showMessage(
          confirmationMessage,
          MessageType.confirmation,
        );

        Navigator.pushNamed(context, '/otp_verification', arguments: _phoneNumberController.text);
      }
    } catch (e) {
      // Handle errors and show a message using the MessageProvider
      if (context.mounted) {
        LoadingOverlay.hide(context); // Close the loading overlay
        messageProvider.showMessage(
          e.toString(),
          MessageType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);

    return BaseScreen(
      leading: null,
      actions: [
        InfoIconButton(),
      ],
      columnWidgets: [
        Expanded(
          flex: 1,
          child: HeaderText(text: "Welcome!"),
        ),
        Expanded(
          flex: 2,
          child: InputField(
            controller: _phoneNumberController,
            hintText: "Enter phone #",
            labelText: "Enter your phone number to get started:",
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () => _sendCodeAndNavigate(context, messageProvider),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}