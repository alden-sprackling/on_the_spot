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
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final isEditing = args != null && args['isEditing'] == true;
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
      if (isEditing) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        if (userProvider.user?.profilePic == null) {
          Navigator.pushReplacementNamed(context, '/set_profile_picture');
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
          );
        }
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
            labelText: 'Enter username',
            hintText: 'RANDOM123',
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
