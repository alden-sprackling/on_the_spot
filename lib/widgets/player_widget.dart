import 'package:flutter/material.dart';
import 'package:on_the_spot/models/lobby_player.dart';

class PlayerWidget extends StatelessWidget {
  final LobbyPlayer player; // Adjust type as needed
  final double containerWidthPercent; // Width percentage for the widget
  final Color? backgroundColor;
  final VoidCallback? onPictureTap;
  final VoidCallback? onTextTap;

  const PlayerWidget({
    super.key,
    required this.player,
    this.containerWidthPercent = 1.0,
    this.backgroundColor,
    this.onPictureTap,
    this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth * containerWidthPercent;
        final avatarWidth = containerWidth * 0.5;
        final fontSize = containerWidth * 0.15;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: containerWidth,
            child: Container(
              color: backgroundColor ?? Colors.transparent,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Picture button
                  InkWell(
                    onTap: onPictureTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: avatarWidth,
                      height: avatarWidth,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          // Assuming player.profilePic holds the URL for image.
                          image: NetworkImage(player.profilePicture!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name and IQ display
                  InkWell(
                    onTap: onTextTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      children: [
                        Text(
                          player.name!,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'IQ: ${player.iq}', // Assuming player.iq exists
                          style: TextStyle(
                            fontSize: fontSize * 0.6,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}