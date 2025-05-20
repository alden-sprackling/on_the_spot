import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserWidget extends StatelessWidget {
  final double containerWidthPercent; // Width percentage for the widget
  final Color? backgroundColor;
  final VoidCallback? onPictureTap; // Callback for the picture button
  final VoidCallback? onTextTap;  // Callback for the text/button below

  const UserWidget({
    super.key,
    this.containerWidthPercent = 1.0, // Default to 100% width
    this.backgroundColor,
    this.onPictureTap,
    this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (user == null) {
          return const Center(
            child: Text(
              'Profile not found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final containerWidth = constraints.maxWidth * containerWidthPercent;
            final avatarWidth = containerWidth * 0.50;
            final fontSize = containerWidth * 0.15;

            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: containerWidth,
                height: containerWidth,
                child: Container(
                  color: backgroundColor ?? Colors.transparent,
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
                              image: NetworkImage(user.profilePic!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Separate button for text
                      InkWell(
                        onTap: onTextTap,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          user.name!,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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