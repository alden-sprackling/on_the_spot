import 'package:flutter/material.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Future<void> _createGame() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (userProvider.user == null) return;

    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    try {
      // Create the lobby with the host's ID and public flag (false)
      await lobbyProvider.createLobby(userProvider.user!.id, false);
      // Navigate to the lobby screen after successful creation
      if (!mounted) return;
      Navigator.pushNamed(context, '/lobby');
    } catch (e) {
      // Show an error message on failure
      messageProvider.addMessage(
        Message(
          content: "Unable to create game lobby: $e",
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> _autoJoinGame() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (userProvider.user == null) return;

    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    try {
      await lobbyProvider.autoJoinLobby(userProvider.user!.id);
      if (!mounted) return;
      Navigator.pushNamed(context, '/lobby');
    } catch (e) {
      // Show an error message on failure
      messageProvider.addMessage(
        Message(
          content: "Unable to auto join game lobby: $e",
          type: MessageType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This Column is exactly what you passed as columnWidgets before
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FieldWidget(
          title: "PLAY",
          children: [
            Button(
              backgroundColor: AppColors.intermediateOrangeRed,
              text: "QUICKPLAY",
              onPressed: () => _autoJoinGame(),
            ),
            Button(
              backgroundColor: AppColors.secondaryColor,
              text: "JOIN GAME",
              onPressed: () {
                Navigator.pushNamed(context, '/join_game');
              },
            ),
            Button(
              backgroundColor: AppColors.primaryColor,
              text: "CREATE GAME",
              onPressed: () => _createGame(),
            ),
          ],
        ),
      ],
    );
  }
}