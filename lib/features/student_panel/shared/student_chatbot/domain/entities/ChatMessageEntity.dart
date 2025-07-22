class ChatMessageEntity {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
}
