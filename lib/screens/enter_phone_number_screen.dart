import 'package:flutter/material.dart';
import 'package:on_the_spot/screens/enter_code_screen.dart';
import 'package:on_the_spot/utils/formatters.dart';
import 'package:on_the_spot/utils/validators.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';
import '../widgets/input_fields/input_field.dart';
import '../widgets/buttons/button.dart';
import '/theme/app_colors.dart';
import 'base_screen.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({super.key});

  @override
  EnterPhoneNumberScreenState createState() => EnterPhoneNumberScreenState();
}

class EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _sendCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    try {
      // Validate the phone number
      final phoneNumber = validatePhoneNumber(
        _phoneNumberController.text.trim(),
      );

      // Send the SMS code
      await authProvider.sendCode(phoneNumber);

      messageProvider.addMessage(
        Message(
          content: "Code sent to $phoneNumber",
          type: MessageType.success,
        ),
      );

      // Navigate to the next screen
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterCodeScreen(phoneNumber: phoneNumber),
        ),
      );
    } catch (e) {
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
      leading: null,
      actions: [
      ],
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 2,
          child: InputField(
            controller: _phoneNumberController,
            labelText: "Enter your phone number to get started:",
            hintText: "(123) 456-7890",
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
            maxLength: 14, // Adjusted for the phone number format
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "SEND CODE >",
            onPressed: _sendCode,
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}