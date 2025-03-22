import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Player extends StatelessWidget {
  final String playerName;
  final String profilePicture;
  final Color? backgroundColor;

  const Player({
    super.key,
    required this.playerName,
    required this.profilePicture,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final containerWidth = constraints.maxWidth; 
        final avatarWidth = containerWidth * 0.70; 
        final fontSize = containerWidth * 0.15;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: containerWidth,
            height: containerWidth,
            child: Container(
              color: backgroundColor ?? Colors.transparent, // Square background color
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: avatarWidth,
                    height: avatarWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/profile_pictures/$profilePicture.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    playerName,
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