import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/screens/base_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  Widget _buildRoundContent(GameProvider gameProv) {
    switch (gameProv.roundState) {
      case RoundState.roundIntroduction:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Round Introduction", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Round: ${gameProv.round}"),
            Text("Difficulty: ${gameProv.difficulty}"),
          ],
        );
      case RoundState.categoryVoteUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Voting for Category", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Current Votes: ${gameProv.voteTally}"),
          ],
        );
      case RoundState.categoryChosen:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category Chosen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Chosen Category: ${gameProv.chosenCategory ?? 'N/A'}"),
          ],
        );
      case RoundState.question:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Question", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // Assuming Question has a field questionText
            Text(gameProv.currentQuestion?.text ?? 'Loading question...'),
          ],
        );
      case RoundState.answerResult:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Answer Result", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Result: ${gameProv.answerResult}"),
          ],
        );
      case RoundState.roundLeaderboard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Round Leaderboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // You can build the leaderboard here by mapping roundLeaderboard to a list of widgets.
            const Text("Leaderboard goes here"),
          ],
        );
      case RoundState.finalLeaderboard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Final Leaderboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // You can build the final leaderboard here.
            const Text("Final leaderboard goes here"),
          ],
        );
      default:
        return const Text("Waiting for round data...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProv, child) {
        return BaseScreen(
          appBarTitle: 'On the Spot',
          mainAxisAlignment: MainAxisAlignment.center,
          columnWidgets: [
            // Persistent info at the top
            Text('Game ID: ${gameProv.gameId}'),
            const SizedBox(height: 16),
            Text('Loaded ${gameProv.categories.length} categories'),
            const SizedBox(height: 24),
            // Switch depending on round state
            _buildRoundContent(gameProv),
          ],
        );
      },
    );
  }
}
