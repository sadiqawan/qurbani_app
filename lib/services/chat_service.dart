import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/massage.dart';
  // Ensure this file is correctly named

class ChatService extends ChangeNotifier {
  // Firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(
      String receiverId, String message, String receiverName) async {
    // Ensure current user is not null
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    final String currentUserId = currentUser.uid;
    final String currentUserEmail = currentUser.email ?? "Unknown";
    final Timestamp timestamp = Timestamp.now();

    // Create a new message object
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Generate chat room ID
    List<String> ids = [currentUserId, receiverId]..sort();
    String chatRoomId = ids.join("_");

    // Add the new message to Firestore
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Update chat room's last message and metadata
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastMessage': message,
      'timestamp': timestamp,
      'participants': ids,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'senderId': currentUserId,
      'receiverName': receiverName,
    }, SetOptions(merge: true)); // Prevent overwriting existing data
  }

  // Get messages between two users
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId]..sort();
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
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firebaseFirestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
