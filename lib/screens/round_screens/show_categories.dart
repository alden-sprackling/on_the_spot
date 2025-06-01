import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/field_widget.dart';

class ShowCategories extends StatelessWidget {
  final GameProvider gameProv;

  const ShowCategories({
    super.key,
    required this.gameProv,
  });

  @override
  Widget build(BuildContext context) {
    return FieldWidget(
      title: "VOTE",
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            return SizedBox(
              width: width,
              height: width, // adjust height as needed
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: gameProv.categories.length,
                itemBuilder: (context, index) {
                  final cat = gameProv.categories[index];
                  final votes = gameProv.voteTally[cat.id] ?? 0;
                  return InkWell(
                    onTap: () async {
                      try {
                        await gameProv.voteCategory(cat.id);
                      } catch (e) {
                        // Optionally handle error, e.g. show a message
                        print("Error voting for category: $e");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(votes.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}