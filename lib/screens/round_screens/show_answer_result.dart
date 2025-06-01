import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';

class ShowAnswerResult extends StatelessWidget {
  final GameProvider gameProv;

  const ShowAnswerResult({
    super.key,
    required this.gameProv,
  });

  @override
  Widget build(BuildContext context) {
    return FieldWidget(
      title: "ANSWER RESULT",
      children: [
        if (gameProv.answerResult != null) ...[
          Center(
            child: BodyText(
              text: gameProv.answerResult!['correct'] ? 'Correct!' : 'Wrong!',
              color: Colors.red,
            ),
          ),
          Center(
            child: BodyText(
              text: "+${gameProv.answerResult!['pointsAwarded']}",
              color: AppColors.lightGrey,
            ),
          ),
        ] else ...[
          Center(
            child: const BodyText(
              text: "No result available.",
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ],
    );
  }
}