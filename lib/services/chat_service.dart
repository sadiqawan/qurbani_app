//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
//
// import '../model/massage.dart';
//
//
// class ChatService extends ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//
//   // Send message
//   Future<void> sendMessage(String receiverId, String message, String receiverName) async {
//     final String currentUserId = _firebaseAuth.currentUser!.uid;
//     final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
//     final Timestamp timestamp = Timestamp.now();
//
//     // Create a new message
//     Message newMessage = Message(
//       senderId: currentUserId,
//       senderEmail: currentUserEmail,
//       receiverId: receiverId,
//       message: message,
//       timestamp: timestamp,
//     );
//
//     // Construct chatRoomId by sorting user IDs to ensure consistent chat room identification
//     List<String> ids = [currentUserId, receiverId];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//
//     // Add new message to the database
//     await _firebaseFirestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .add(newMessage.toMap());
//
//     // Update chat room's last message and timestamp
//     await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).set({
//       'lastMessage': message,
//       'timestamp': timestamp,
//       'participants': ids,
//       'senderEmail': currentUserEmail,
//       'receiverId': receiverId,
//       'receiverName': receiverName,
//     });
//   }
//
//   // Get messages for a specific chat room
//   Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
//     List<String> ids = [userId, otherUserId];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//
//     return _firebaseFirestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
//
//   // Get chat list for the current user
//   Stream<QuerySnapshot> getChatList() {
//     final String currentUserId = _firebaseAuth.currentUser!.uid;
//
//     return _firebaseFirestore
//         .collection('chat_rooms')
//         .where('participants', arrayContains: currentUserId)
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }
// }
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/massage.dart';


class ChatService extends ChangeNotifier {
  // geting of instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Send massage
  Future<void> sandMassage(
      String receiverId, String message, String receiverName) async {
    // get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new massage

    Message newMassage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct a chatRoom id form current user id and receiver id

    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // for creating new chat room id
    String chatRoomId = ids.join("_"); // combine them with single _

    // add new massage to the data base

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMassage.toMap());

    // Update chat room's last message and timestamp
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastMessage': message,
      'timestamp': timestamp,
      'participants': ids,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'senderId': _firebaseAuth.currentUser!.uid,
      'receiverName': receiverName,
    });
  }

// Get massage

  Stream<QuerySnapshot> getMassages(String userId, String otherUserId) {
    // construct chatRoom id form user  ids (sort them to ensure the id when sending)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // get all the list of user who have sand massage

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
