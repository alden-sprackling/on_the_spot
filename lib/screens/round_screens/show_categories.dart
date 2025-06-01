import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/game_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';

class ShowCategories extends StatelessWidget {
  final GameProvider gameProv;

  const ShowCategories({
    super.key,
    required this.gameProv,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> gridColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label text similar to SetProfilePictureScreen
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: BodyText(
                  text: 'Vote on a category for this round',
                ),
              ),
              SizedBox(
                width: width,
                height: width * 1.5,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
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
                          print("Error voting for category: $e");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColors[index % gridColors.length],
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            // Votes positioned on the top right
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Text(
                                votes.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            // Category name centered
                            Center(
                              child: Text(
                                cat.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}