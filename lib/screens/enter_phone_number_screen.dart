import 'package:flutter/material.dart';
import 'package:on_the_spot/screens/enter_code_screen.dart';
import 'package:on_the_spot/utils/formatters.dart';
import 'package:on_the_spot/utils/validators.dart';
import 'package:on_the_spot/widgets/text/header_text.dart';
import 'package:on_the_spot/widgets/icons/info_icon_button.dart';
import 'package:provider/provider.dart';
import '../models/system_message.dart';
import '../providers/auth_provider.dart';
import '../providers/system_message_provider.dart';
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
    final systemMessageProvider = Provider.of<SystemMessageProvider>(context, listen: false);
    try {
      // Validate the phone number
      final phoneNumber = validatePhoneNumber(
        _phoneNumberController.text.trim(),
      );

      // Send the SMS code
      await authProvider.sendSMSCode(phoneNumber);

      systemMessageProvider.addMessage(
        SystemMessage(
          content: "Code sent to $phoneNumber",
          type: SystemMessageType.success,
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
            labelText: "Enter your phone number to get started:",
            hintText: "Enter phone #",
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
            maxLength: 10,
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