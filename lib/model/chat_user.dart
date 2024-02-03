import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String id;
  String name;
  String avatarUrl;

  ChatUser({required this.id, required this.name, required this.avatarUrl});

  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChatUser(
      id: doc.id,
      name: data['name'],
      avatarUrl: data['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}
