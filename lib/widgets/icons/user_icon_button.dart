import 'package:flutter/material.dart';

class UserIconButton extends StatelessWidget {
  final String profilePic;
  final String name;
  final int iq;
  final VoidCallback? onPressed;

  const UserIconButton({
    super.key,
    required this.profilePic,
    required this.name,
    required this.iq,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePic),
          ),
          const SizedBox(width: 12.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'IQ: $iq',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}