import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/const/contant_style.dart';
import 'package:medally_pro/views/nave_view/chat/user_chatting_screen.dart';
import '../../../services/chat_service.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatService chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getChatList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Cheating',
                style: kSubTitle2B,
              ),
              backgroundColor: kPriemryColor,
            ),
            body: Center(
              child: Text(
                "Chat list is empty.",
                style: kSubTitle2B,
              ),
            ),
          );
        }

        var userChatList = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Cheating',
              style: kSubTitle2B,
            ),
            backgroundColor: kPriemryColor,
          ),
          body: ListView.builder(
            itemCount: userChatList.length,
            itemBuilder: (context, index) {
              final chat = userChatList[index];
              final chatData = chat.data() as Map<String, dynamic>;
              final receiverName = chatData['receiverName'] ?? "User";
              final lastMessage = chatData['lastMessage'] ?? 'No messages yet';
              final receiverId = chatData['receiverId'];

              return ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
                title: Text(receiverName, style: kSubTitle2B),
                subtitle: Text(lastMessage),
                onTap: () {
                  final currentUserId = _firebaseAuth.currentUser?.uid;
                  if (currentUserId != null) {
                    Get.to(
                      UserChattingScreen(
                        receiverId: receiverId,
                          receiverName:receiverName,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
