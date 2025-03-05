import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final containerWidth = constraints.maxWidth;
        final avatarWidth = containerWidth * 0.75;
        final fontSize = containerWidth * 0.1;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: containerWidth,
            height: containerWidth,
            child: Container(
              color: Colors.transparent, // Square background color
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: avatarWidth,
                    height: avatarWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/profile_pictures/${playerProvider.profilePicture}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    playerProvider.playerName,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightGrey,
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