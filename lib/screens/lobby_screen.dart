import 'package:flutter/material.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/screens/base_screen.dart';
import 'package:on_the_spot/widgets/icons/back_icon_button.dart';
import 'package:on_the_spot/widgets/icons/toggle_icon.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';
import 'package:on_the_spot/widgets/user_list_widget.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  @override
  void initState() {
    super.initState();
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    context.read<LobbyProvider>().socketService!.onError.listen((msg) {
      messageProvider.addMessage(
        Message(
          content: msg,
          type: MessageType.error,
        ),
      );
    });
  }

  Future<void> _startGame(LobbyProvider lobbyProv) async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);

    try {
      lobbyProv.socketService!.startGame(
        lobbyProv.lobby!.hostId,
        lobbyProv.lobby!.code,
      );
    } catch (e) {
      messageProvider.addMessage(
        Message(
          content: 'Unable to start game: $e',
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> _initGame(LobbyProvider lobbyProv) async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    try {
      await gameProvider.initGame(lobbyProv.gameId!);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
              context,
              '/game',
              (Route<dynamic> route) => false,
            );
    } catch (e) {
      messageProvider.addMessage(
        Message(
          content: 'Unable to initialize game: $e',
          type: MessageType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LobbyProvider, UserProvider>(
      builder: (context, lobbyProv, userProvider, _) {
        // If lobby becomes null at any point, simply return an empty scaffold.
        if (lobbyProv.lobby == null) {
          return const Scaffold(
            body: Center(child: Text('No lobby data.')),
          );
        }

        if (lobbyProv.gameStarted) {
          _initGame(lobbyProv);
        }

        final bool isHost = userProvider.user != null &&
            lobbyProv.lobby!.hostId == userProvider.user!.id;
        final bool hasMinPlayers =
            lobbyProv.lobby!.players.length >= 2;

        Widget content;
        Widget buttonWidget;

        if (lobbyProv.isLoading) {
          content = const Center(child: CircularProgressIndicator());
          buttonWidget = const SizedBox.shrink();
        } else {
          final players = lobbyProv.players;
          List<Widget> playerWidgets = [];

          if (players.isNotEmpty) {
            playerWidgets.addAll(
              players.map((player) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: UserListWidget(
                    profilePic: player.profilePicture!,
                    name: player.name!,
                    iq: player.iq,
                    // Set isHost based on lobby hostId.
                    isHost: player.id == lobbyProv.lobby!.hostId,
                    onPressed: () {
                      // Optionally handle tap on the player icon.
                    },
                  ),
                );
              }).toList(),
            );
          }
          
          // FieldWidget shows the players and the lobby title.
          content = FieldWidget(
            title: 'LOBBY',
            children: playerWidgets,
          );
          
          // The start button (or waiting text) appears below the FieldWidget.
          buttonWidget = isHost
              ? Button(
                  text: 'START',
                  backgroundColor: hasMinPlayers ? Colors.green : Colors.green.withAlpha((0.5 * 255).toInt()),
                  onPressed: () {
                    hasMinPlayers ? _startGame(lobbyProv) : null;
                  },
                )
              : const BodyText(
                  text: 'Waiting for host...',
                  color: AppColors.lightGrey,
                );
        }

        return BaseScreen(
          appBarTitle: lobbyProv.lobby!.code,
          leading: BackIconButton(
            extraOnPressed: () async {
              if (lobbyProv.lobby != null && userProvider.user != null) {
                lobbyProv.socketService!.leaveLobby(
                  userProvider.user!.id,
                  lobbyProv.lobby!.code,
                );
              }
            },
          ),
          actions: [
            // Only show ToggleIcon if lobby is not null.
            if (lobbyProv.lobby != null)
              ToggleIcon(
                isPublic: lobbyProv.lobby!.isPublic,
                onPressed: isHost
                    ? () {
                        // Toggle the public flag by using the inverse of the current value.
                        lobbyProv.socketService!.togglePrivacy(
                          lobbyProv.lobby!.hostId,
                          lobbyProv.lobby!.code,
                          !lobbyProv.lobby!.isPublic,
                        );
                      }
                    : null,
              ),
          ],
          columnWidgets: [
            Expanded(child: SingleChildScrollView(child: content)),
            SizedBox(
              height: 32,
            ),
            buttonWidget
          ],
        );
      },
    );
  }
}