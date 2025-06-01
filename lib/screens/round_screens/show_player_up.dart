import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/player_widget.dart';

class ShowPlayerUp extends StatelessWidget {
  final GameProvider gameProv;
  final LobbyProvider lobbyProv;

  const ShowPlayerUp({
    super.key,
    required this.gameProv,
    required this.lobbyProv,
  });

  @override
  Widget build(BuildContext context) {
    final playerUpId = gameProv.playerUp;
    final lobbyPlayer = lobbyProv.players.firstWhere(
      (player) => player.id == playerUpId,
    );
    return FieldWidget(
      title: "PLAYER UP",
      children: [
        PlayerWidget(
          player: lobbyPlayer,
        ),
      ],
    );
  }
}