import 'chat_message.dart';

class Chat {
  String id;
  List<ChatMessage> messages;

  Chat({required this.id, required this.messages});
}