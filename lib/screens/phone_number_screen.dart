import 'package:flutter/material.dart';
import 'package:on_the_spot/utils/phone_number_formatter.dart';
import 'package:on_the_spot/widgets/header_text.dart';
import 'package:on_the_spot/widgets/info_icon_button.dart';
import '/widgets/input_field.dart';
import '/widgets/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../providers/player_provider.dart';
import 'base_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  PhoneNumberScreenState createState() => PhoneNumberScreenState();
}

class PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

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
            controller: _controller,
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
            onPressed: () {
              try {
                playerProvider.setPhoneNumber(_controller.text);
                Navigator.pushNamed(context, '/otp_verification'); // Navigate to the next screen
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