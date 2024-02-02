class ChatMessage {
  String id;
  String senderId;
  String text;
  DateTime timestamp;
  bool isSentByMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });
}