import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/chat.dart';
import '../model/chat_message.dart';
import 'package:path/path.dart' as path;

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User get _user {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user currently signed in.',
      );
    }
    return user;
  }

  //List of chats for the current user.
  Stream<List<Chat>> getChatsStream() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: _user.uid)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => Chat.fromFirestore(doc))
        .toList());
  }

  //Send a text message in a chat.
  Future<void> sendMessage(String chatId, String text) async {
    final messageRef = _firestore.collection('chats').doc(chatId).collection('messages');

    await messageRef.add({
      'senderId': _user.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text', // 'text' or 'image' to distinguish message types
    });
  }

  //List of messages for a chat.
  Stream<List<ChatMessage>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => ChatMessage.fromFirestore(doc))
        .toList());
  }

  //Send a photo message in a chat.
  Future<void> sendPhoto(String chatId, File imageFile) async {
    String fileName = path.basename(imageFile.path);
    Reference storageRef = _storage.ref().child(
        'chat_images/$chatId/$fileName');

    //Upload the photo to Firebase Storage
    UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => null);

    //Once the upload is complete, get the photo URL
    String photoUrl = await storageRef.getDownloadURL();

    //Add a new message with the photo URL to the chat's message collection
    final messageRef = _firestore.collection('chats').doc(chatId).collection(
        'messages');
    await messageRef.add({
      'senderId': _user.uid,
      'imageUrl': photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'image',
    });
  }
}