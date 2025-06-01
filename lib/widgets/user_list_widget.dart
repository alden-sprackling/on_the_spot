import 'package:flutter/material.dart';
import 'package:on_the_spot/widgets/icons/user_icon_button.dart';

/// Converts a number to its ordinal string version. For example: 1 -> 1st, 2 -> 2nd.
String ordinal(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return '${number}th';
  }
  switch (number % 10) {
    case 1:
      return '${number}st';
    case 2:
      return '${number}nd';
    case 3:
      return '${number}rd';
    default:
      return '${number}th';
  }
}

class UserListWidget extends StatelessWidget {
  final int? placement;
  final String profilePic;
  final String name;
  final int iq;
  final int? gamePoints;
  final int? iqDelta;
  final bool isHost;
  final VoidCallback? onPressed;

  const UserListWidget({
    super.key,
    this.placement,
    required this.profilePic,
    required this.name,
    required this.iq,
    this.gamePoints,
    this.iqDelta,
    this.isHost = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Placement number (if provided) as ordinal text (e.g., "1st", "2nd")
          if (placement != null)
            Text(
              ordinal(placement!),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (placement != null) const SizedBox(width: 16.0),
          // User icon button occupies available space
          Expanded(
            child: UserIconButton(
              profilePic: profilePic,
              name: name,
              iq: iq,
              onPressed: onPressed,
            ),
          ),
          // If the user is the host, show a "HOST" label to the right of the icon.
          if (isHost) ...[
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Text(
                'HOST',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          // Right side: game points and IQ adjustments (if any)
          if (gamePoints != null || iqDelta != null)
            const SizedBox(width: 8.0),
          if (gamePoints != null || iqDelta != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (gamePoints != null)
                  Text(
                    'Points: $gamePoints',
                    style: const TextStyle(fontSize: 14),
                  ),
                if (iqDelta != null)
                  Text(
                    'IQ Adj: $iqDelta',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}