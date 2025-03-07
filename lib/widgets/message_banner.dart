import 'package:flutter/material.dart';
import '../providers/message_provider.dart'; 

class MessageBanner extends StatefulWidget {
  final String? message;
  final MessageType? type;

  const MessageBanner({
    super.key,
    this.message,
    this.type,
  });

  @override
  MessageBannerState createState() => MessageBannerState();
}

class MessageBannerState extends State<MessageBanner> {
  @override
  Widget build(BuildContext context) {
    if (widget.message == null || widget.type == null) {
      return SizedBox.shrink();
    }

    Color backgroundColor;

    switch (widget.type) {
      case MessageType.error:
        backgroundColor = Colors.red;
        break;
      case MessageType.warning:
        backgroundColor = Colors.yellow;
        break;
      case MessageType.confirmation:
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.transparent;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
      color: backgroundColor,
      child: Text(
        widget.message!,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}