import 'package:flutter/material.dart';
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

  /// Calls updateUsername from the UserProvider with the text from _nameController.
  /// If the update succeeds, you can navigate to the next screen or show a success message.
  /// Otherwise, handles the error (e.g. by showing a system message).
  void _setName() async {
    final newUsername = _nameController.text.trim();
    if (newUsername.isEmpty) {
      // Optionally handle empty input, for example:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .updateUsername(newUsername);
      // Optionally navigate to the next screen or show success message.
    } catch (e) {
      // Optionally handle error, e.g. show a system message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update username')),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: null,
      actions: null,
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _nameController,
            labelText: "How do you want to be seen by other players?",
            hintText: "Enter nickname",
            keyboardType: TextInputType.text,
            inputFormatters: [UsernameFormatter()], 
            maxLength: 12,
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () => _setName,
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}