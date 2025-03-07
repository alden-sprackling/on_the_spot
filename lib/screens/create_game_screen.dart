import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/back_icon_button.dart';
import '../widgets/player.dart';
import 'base_screen.dart';
import '../providers/game_provider.dart';

class CreateGameScreen extends StatelessWidget {
  const CreateGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = context.watch<GameProvider>().players;

    return BaseScreen(
      leading: BackIconButton(),
      columnWidgets: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 12.0, // Horizontal spacing
              mainAxisSpacing: 12.0, // Vertical spacing
            ),
            itemCount: players.length,
            itemBuilder: (context, index) {
              return Player(
                playerName: players[index]["name"]!,
                profilePicture: players[index]["profilePicture"]!,
              );
            },
          ),
        ),
      ],
    );
  }
}