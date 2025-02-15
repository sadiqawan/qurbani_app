import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/massage.dart';


class ChatService extends ChangeNotifier {
  // Get instances of Firebase Auth and Firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(
      String receiverId, String message, String receiverName) async {
    // Get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room ID from current user ID and receiver ID
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // Ensure consistent chat room ID
    String chatRoomId = ids.join("_");

    // Add new message to the database
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Update chat room's last message and timestamp
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastMessage': message,
      'timestamp': timestamp,
      'participants': ids,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'senderId': currentUserId,
      'receiverName': receiverName,
    }, SetOptions(merge: true));
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort(); // Ensure consistent chat room ID
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get chat list for the current user
  Stream<QuerySnapshot> getChatList() {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    return _firebaseFirestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}