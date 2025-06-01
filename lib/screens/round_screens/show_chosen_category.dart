import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';

class ShowChosenCategory extends StatelessWidget {
  final GameProvider gameProv;

  const ShowChosenCategory({
    super.key,
    required this.gameProv,
  });

  @override
  Widget build(BuildContext context) {
    final chosenCategory = gameProv.categories.firstWhere(
      (cat) => cat.id == gameProv.chosenCategory,
    );

    return FieldWidget(
      title: "CATEGORY CHOSEN",
      children: [
        Center(child: BodyText(text: chosenCategory.name, color: Colors.red,)),
      ],
    );
  }
}