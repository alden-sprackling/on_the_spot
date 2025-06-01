import 'package:flutter/material.dart';
import 'package:on_the_spot/models/game_player.dart';
import 'package:on_the_spot/models/lobby_player.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/user_list_widget.dart';
import 'package:provider/provider.dart';

class ShowFinalLeaderboard extends StatefulWidget {
  final GameProvider gameProv;
  final LobbyProvider lobbyProv;

  const ShowFinalLeaderboard({
    super.key,
    required this.gameProv,
    required this.lobbyProv,
  });

  @override
  State<ShowFinalLeaderboard> createState() => _ShowFinalLeaderboardState();
}

class _ShowFinalLeaderboardState extends State<ShowFinalLeaderboard> {
  @override
  void initState() {
    super.initState();
    // Fetch updated profile info on init.
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the final leaderboard from GameProvider.
    final List<GamePlayer> gamePlayers = widget.gameProv.finalLeaderboard;
    
    // Merge GamePlayer and LobbyPlayer data.
    List<Map<String, dynamic>> leaderboardData = [];
    for (var gamePlayer in gamePlayers) {
      final lobbyPlayer = widget.lobbyProv.players.firstWhere(
        (player) => player.id == gamePlayer.userId,
        orElse: () => LobbyPlayer(
          phoneNumber: '',
          id: gamePlayer.userId,
          name: 'Unknown',
          profilePicture: '',
          iq: 0,
        ),
      );
      leaderboardData.add({
        'userId': gamePlayer.userId,
        'gamePoints': gamePlayer.pointsTotal,
        'profilePic': lobbyPlayer.profilePicture,
        'name': lobbyPlayer.name,
        'iq': lobbyPlayer.iq,
        'iqDelta': gamePlayer.iqDelta, // Include IQ delta.
      });
    }
    
    // Sort descending by gamePoints.
    leaderboardData.sort(
      (a, b) => (b['gamePoints'] as int).compareTo(a['gamePoints'] as int),
    );
    
    // Compute placements with ties sharing the placement.
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
          iqDelta: data['iqDelta'] as int?,
        ),
      );
    }
    
    // Wrap the leaderboard in a FieldWidget and add a home IconButton below.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldWidget(
          title: "FINAL LEADERBOARD",
          children: leaderboardWidgets,
        ),
        const SizedBox(height: 16),
        Button(
          text: "HOME",
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
          },
          backgroundColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}