import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  List<String> participants;

  Chat({required this.id, required this.participants});

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Chat(
      id: doc.id,
      participants: List<String>.from(data['participants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
    };
  }
}
