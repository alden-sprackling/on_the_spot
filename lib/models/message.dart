/// Represents a system-level message with a type and content.
class Message {
  final String content; // The content of the system message
  final MessageType type; // The type of the system message (e.g., error, warning, confirmation)

  Message({required this.content, required this.type});
}

/// Represents the type of a system message.
enum MessageType {
  error,
  warning,
  success,
  chat,
}