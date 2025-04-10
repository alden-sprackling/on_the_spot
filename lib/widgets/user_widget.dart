import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/user_provider.dart';

class UserWidget extends StatelessWidget {
  final double containerWidthPercent; // New parameter for width percentage
  final Color? backgroundColor;

  const UserWidget({
    super.key,
    this.containerWidthPercent = 1.0, // Default to 100% width
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, playerProvider, child) {
        final player = playerProvider.user;

        if (player == null) {
          return const Center(
            child: Text(
              'No player data available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final containerWidth = constraints.maxWidth * containerWidthPercent; // Apply percentage
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
                            image: AssetImage('assets/profile_pictures/${player.profilePicture}.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        player.username,
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
      },
    );
  }
}