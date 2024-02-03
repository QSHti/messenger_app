import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id;
  String senderId;
  String text;
  DateTime timestamp;
  bool isSentByMe;
  String? imageUrl;
  String type;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
    this.imageUrl,
    required this.type,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'],
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isSentByMe: false,
      imageUrl: data['imageUrl'],
      type: data['type'],
    );
  }
}
