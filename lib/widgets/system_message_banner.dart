import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_message_provider.dart';
import '../models/system_message.dart';

class MessageBanner extends StatelessWidget {
  const MessageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemMessageProvider>(
      builder: (context, systemMessageProvider, child) {
        final systemMessages = systemMessageProvider.systemMessages;

        if (systemMessages.isEmpty) {
          return SizedBox.shrink(); // No messages to display
        }

        return Column(
          children: systemMessages.map((systemMessage) {
            // Automatically remove the message after 4 seconds
            Future.delayed(const Duration(seconds: 4), () {
              systemMessageProvider.removeMessage(systemMessage);
            });

            return Container(
              width: double.infinity, // Stretch across the screen
              color: _getMessageColor(systemMessage.type),
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getMessageIcon(systemMessage.type),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      systemMessage.content,
                      style: const TextStyle(color: Colors.white),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _getMessageColor(SystemMessageType type) {
    switch (type) {
      case SystemMessageType.error:
        return Colors.red;
      case SystemMessageType.warning:
        return Colors.orange;
      case SystemMessageType.success:
        return Colors.green;
    }
  }

  IconData _getMessageIcon(SystemMessageType type) {
    switch (type) {
      case SystemMessageType.error:
        return Icons.error;
      case SystemMessageType.warning:
        return Icons.warning;
      case SystemMessageType.success:
        return Icons.check_circle;
    }
  }
}