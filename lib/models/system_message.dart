/// Represents a system-level message with a type and content.
class SystemMessage {
  final String content; // The content of the system message
  final SystemMessageType type; // The type of the system message (e.g., error, warning, confirmation)

  SystemMessage({required this.content, required this.type});
}

/// Represents the type of a system message.
enum SystemMessageType {
  error,
  warning,
  success,
}