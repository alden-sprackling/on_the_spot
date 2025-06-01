import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/screens/round_screens/show_answer_result.dart';
import 'package:on_the_spot/screens/round_screens/show_chosen_category.dart';
import 'package:on_the_spot/screens/round_screens/show_final_leaderboard.dart';
import 'package:on_the_spot/screens/round_screens/show_player_up.dart';
import 'package:on_the_spot/screens/round_screens/show_question.dart';
import 'package:on_the_spot/screens/round_screens/show_round_introduction.dart';
import 'package:on_the_spot/screens/round_screens/show_categories.dart';
import 'package:on_the_spot/screens/round_screens/show_round_leaderboard.dart';
import 'package:on_the_spot/widgets/bottom_popup.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import 'package:on_the_spot/widgets/icons/message_icon_button.dart';
import 'package:on_the_spot/widgets/icons/timer_icon.dart';
import 'package:on_the_spot/widgets/input_fields/input_field.dart';
import 'package:provider/provider.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/screens/base_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  Widget _buildRoundContent(GameProvider gameProv, LobbyProvider lobbyProv, UserProvider userProv) {
    switch (gameProv.roundState) {
      case RoundState.roundIntroduction:
        return ShowRoundIntroduction(gameProv: gameProv);
      case RoundState.categoryVoteUpdate:
        return ShowCategories(gameProv: gameProv);
      case RoundState.categoryChosen:
        return ShowChosenCategory(gameProv: gameProv);
      case RoundState.playerUp:
        return ShowPlayerUp(
          gameProv: gameProv,
          lobbyProv: lobbyProv,
        );
      case RoundState.question:
        return ShowQuestion(
          gameProv: gameProv,
          currentUserId: userProv.user!.id, // Pass the current user's id here
          lobbyProv: lobbyProv,
        );
      case RoundState.answerResult:
        return ShowAnswerResult(gameProv: gameProv);
      case RoundState.roundLeaderboard:
        return ShowRoundLeaderboard(
          gameProv: gameProv,
          lobbyProv: lobbyProv,
        );
      case RoundState.finalLeaderboard:
        return ShowFinalLeaderboard(
          gameProv: gameProv,
          lobbyProv: lobbyProv,
        );
      default:
        return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lobbyProv = Provider.of<LobbyProvider>(context);
    final userProv = Provider.of<UserProvider>(context);
    return Consumer<GameProvider>(
      builder: (context, gameProv, child) {
        return Stack(
          children: [
            BaseScreen(
              resizeToAvoidBottomInset: false,
              actions: [
                if (gameProv.roundState != RoundState.finalLeaderboard && gameProv.roundState != RoundState.roundIntroduction && gameProv.roundState != RoundState.playerUp && gameProv.roundState != RoundState.categoryChosen && gameProv.roundState != RoundState.roundLeaderboard && gameProv.roundState != RoundState.answerResult)
                  TimerIcon(
                    duration: gameProv.duration,
                  ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              columnWidgets: [
                // Switch depending on round state
                _buildRoundContent(gameProv, lobbyProv, userProv),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: MessageIconButton(
                onPressed: () {
                  final TextEditingController messageController = TextEditingController();
                  BottomPopup.show(
                    context: context,
                    children: [
                      InputField(
                        fillColor: Colors.transparent,
                        controller: messageController,
                        hintText: "Type your message",
                      ),
                      const SizedBox(height: 16),
                      Button(
                        text: "SEND",
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await gameProv.sendMessage(messageController.text.trim());
                          navigator.pop();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}