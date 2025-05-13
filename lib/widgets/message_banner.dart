import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../models/message.dart';
import 'text/body_text.dart';

class MessageBanner extends StatelessWidget {
  const MessageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, messageProvider, child) {
        final messages = messageProvider.messages;

        if (messages.isEmpty) {
          return SizedBox.shrink(); // No messages to display
        }

        return Column(
          children: messages.map((systemMessage) {
            // Automatically remove the message after 4 seconds
            Future.delayed(const Duration(seconds: 4), () {
              messageProvider.removeMessage(systemMessage);
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
                    child: BodyText(
                      text: systemMessage.content,
                      color: Colors.white,
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

  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.success:
        return Colors.green;
      case MessageType.chat:
        return Colors.blue;
    }
  }

  IconData _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.chat:
        return Icons.chat;
    }
  }
}