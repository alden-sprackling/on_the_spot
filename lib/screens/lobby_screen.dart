import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
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

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LobbyProvider, UserProvider>(
      builder: (context, lobbyProv, userProvider, _) {
        Widget content;

        if (lobbyProv.isLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else {
          final players = lobbyProv.players;
          if (players.isEmpty) {
            content = const Center(child: Text('Waiting for players to join...'));
          } else {
            content = FieldWidget(
              title: 'LOBBY: ${lobbyProv.lobby!.code}',
              children: players.map((player) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: UserListWidget(
                    profilePic: player.profilePicture ?? '',
                    name: player.name ?? 'Guest',
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
        }

        final bool isHost = lobbyProv.lobby != null &&
            userProvider.user != null &&
            lobbyProv.lobby!.hostId == userProvider.user!.id;

        return BaseScreen(
          leading: BackIconButton(
            extraOnPressed: () async {
              if (lobbyProv.lobby != null && userProvider.user != null) {
                await lobbyProv.leaveLobby(
                  lobbyProv.lobby!.code,
                  userProvider.user!.id,
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
                        lobbyProv.socketService!.togglePrivacy(lobbyProv.lobby!.hostId, lobbyProv.lobby!.code, !lobbyProv.lobby!.isPublic);
                      }
                    : null,
              ),
          ],
          columnWidgets: [
            Expanded(child: content),
            const SizedBox(height: 24.0),
            isHost
                ? Button(
                    text: 'START',
                    backgroundColor: Colors.green,
                    onPressed: () {
                      lobbyProv.socketService!.startGame(
                        lobbyProv.lobby!.hostId,
                        lobbyProv.lobby!.code,
                      );
                    },
                  )
                : const BodyText(
                    text: 'Waiting for host...',
                    color: AppColors.lightGrey,
                  ),
          ],
        );
      },
    );
  }
}