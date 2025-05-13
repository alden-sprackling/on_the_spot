import 'package:flutter/material.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/icons/back_icon_button.dart';
import '../widgets/input_fields/input_field.dart';
import '../widgets/buttons/button.dart';
import '../theme/app_colors.dart';
import 'base_screen.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _joinLobby() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (userProvider.user == null) return;

    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    try {
      // Create the lobby with the host's ID and public flag (false)
      await lobbyProvider.joinLobby(_controller.text.trim(), userProvider.user!.id);
      // Navigate to the lobby screen after successful creation
      if (!mounted) return;
      Navigator.pushNamed(context, '/lobby');
    } catch (e) {
      // Show an error message on failure
      messageProvider.addMessage(
        Message(
          content: "Unable to join game lobby",
          type: MessageType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: BackIconButton(),
      columnWidgets: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: InputField(
            controller: _controller,
            hintText: "Enter game code",
          ),
        ),
        Expanded(
          flex: 0,
          child: Button(
            text: "CONTINUE >",
            onPressed: () {
              _joinLobby();
            },
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}