import 'package:flutter/material.dart';
import 'package:on_the_spot/models/game_player.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/user_list_widget.dart';

class ShowRoundLeaderboard extends StatelessWidget {
  final GameProvider gameProv;
  final LobbyProvider lobbyProv;

  const ShowRoundLeaderboard({
    super.key,
    required this.gameProv,
    required this.lobbyProv,
  });

  @override
  Widget build(BuildContext context) {
    // Get game players from game provider
    final List<GamePlayer> gamePlayers = gameProv.roundLeaderboard;
    // Merge game data with lobby player information
    List<Map<String, dynamic>> leaderboardData = [];
    for (var gamePlayer in gamePlayers) {
      final lobbyPlayer = lobbyProv.players.firstWhere(
        (player) => player.id == gamePlayer.userId,
      );
      leaderboardData.add({
          'userId': gamePlayer.userId,
          'gamePoints': gamePlayer.pointsTotal,
          'profilePic': lobbyPlayer.profilePicture,
          'name': lobbyPlayer.name,
          'iq': lobbyPlayer.iq,
        });
    }

    // Sort descending by game points.
    leaderboardData.sort(
      (a, b) => (b['gamePoints'] as int).compareTo(a['gamePoints'] as int),
    );

    // Compute placements, sharing positions if points are equal.
    int placement = 1;
    int count = 0;
    int? lastPoints;
    List<Widget> leaderboardWidgets = [];

    for (var data in leaderboardData) {
      count++;
      final int points = data['gamePoints'] as int;
      if (lastPoints == null || points != lastPoints) {
        placement = count;
      }
      lastPoints = points;
      leaderboardWidgets.add(
        UserListWidget(
          placement: placement,
          profilePic: data['profilePic'] ?? '',
          name: data['name'] ?? 'Unknown',
          gamePoints: data['gamePoints'] as int,
          iq: data['iq'] as int,
        ),
      );
    }

    // Wrap the leaderboard in a FieldWidget.
    return FieldWidget(
      title: "ROUND LEADERBOARD",
      children: leaderboardWidgets,
    );
  }
}