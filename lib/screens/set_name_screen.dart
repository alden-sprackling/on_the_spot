import 'package:flutter/material.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/utils/validators.dart';
import '../utils/formatters.dart';
import '../widgets/input_fields/input_field.dart';
import '../widgets/buttons/button.dart';
import '/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'base_screen.dart';

class SetNameScreen extends StatefulWidget {
  const SetNameScreen({super.key});

  @override
  SetNameScreenState createState() => SetNameScreenState();
}

class SetNameScreenState extends State<SetNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  /// Calls updateProfile from the UserProvider with the text from _nameController.
  /// If the update succeeds, navigates appropriately; otherwise, shows an error message.
  Future<void> _setName() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final username = validateUsername(_nameController.text.trim());
      await userProvider.updateProfile(name: username);
      messageProvider.addMessage(
        Message(
          content: 'Username updated successfully!',
          type: MessageType.success,
        ),
      );

      userProvider.fetchProfile();
      if (userProvider.user?.profilePic == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/set_profile_picture');
      } else {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      }
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
      actions: null,
      columnWidgets: [
        const Spacer(flex: 1),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _nameController,
            labelText: 'How do you want to be seen by other players?',
            hintText: 'Enter username',
            keyboardType: TextInputType.text,
            inputFormatters: [UsernameFormatter()],
            maxLength: 12,
          ),
        ),
        Button(
          text: 'CONTINUE >',
          onPressed: _setName,
          backgroundColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
