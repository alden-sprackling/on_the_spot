import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/input_fields/input_field.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';

class ShowQuestion extends StatefulWidget {
  final GameProvider gameProv;
  final String currentUserId;
  final LobbyProvider lobbyProv;

  const ShowQuestion({
    super.key,
    required this.gameProv,
    required this.currentUserId,
    required this.lobbyProv,
  });

  @override
  ShowQuestionState createState() => ShowQuestionState();
}

class ShowQuestionState extends State<ShowQuestion> {
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlayerUp = widget.gameProv.playerUp == widget.currentUserId;
    
    // Find the waiting player's name by matching the id in lobbyProv.players.
    final waitingPlayer = widget.lobbyProv.players.firstWhere(
      (player) => player.id == widget.gameProv.playerUp,
    );
    final waitingName = waitingPlayer.name ?? "player";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Field widget for displaying the question.
        FieldWidget(
          title: "QUESTION",
          children: [
            BodyText(
              text: widget.gameProv.currentQuestion ?? 'Loading question...',
              color: Colors.black,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Section for answering.
        if (isPlayerUp) ...[
          FieldWidget(
            title: "ANSWER",
            children: [
              InputField(
                controller: _answerController,
                hintText: "Answer here",
              ),
            ],
          ),
          const SizedBox(height: 16),
          Button(
            text: "SUBMIT",
            onPressed: () async {
              await widget.gameProv.submitAnswer(_answerController.text.trim());
              _answerController.clear();
            },
            backgroundColor: Colors.green,
          ),
        ] else
          Center(
            child: BodyText(
              text: "Waiting for '$waitingName'...",
              color: AppColors.lightGrey,
            ),
          ),
      ],
    );
  }
}