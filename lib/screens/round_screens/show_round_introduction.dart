import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/text/header_text.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';
import 'package:on_the_spot/widgets/field_widget.dart';

class ShowRoundIntroduction extends StatelessWidget {
  final GameProvider gameProv;

  const ShowRoundIntroduction({
    super.key,
    required this.gameProv,
  });

  @override
  Widget build(BuildContext context) {
    return FieldWidget(
      title: "",
      children: [
        // Animated header text
        Center(
          child: HeaderText(
            text: "Round ${gameProv.round}",
          ),
        ),
        // Animated body text for difficulty
        Center(
          child: BodyText(
            text: "${gameProv.difficulty}: ${gameProv.points} points",
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }
}