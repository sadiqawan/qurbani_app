import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/const/contant_style.dart';
import '../../../services/chat_service.dart';

class UserChattingScreen extends StatefulWidget {
  final String receiverId;
  final String userName;

  const UserChattingScreen({
    super.key,
    required this.receiverId,
    required this.userName,
  });

  @override
  State<UserChattingScreen> createState() => _UserChattingScreenState();
}

class _UserChattingScreenState extends State<UserChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text.trim(),
        widget.userName,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhit,
          appBar: AppBar(
            backgroundColor: kPriemryColor,
            title: Text(widget.userName, style: kSmallTitle1),
            centerTitle: true,
            elevation: 1,
          ),
          body: Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildMessageInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: _chatService.getMessages(
          _firebaseAuth.currentUser!.uid,
          widget.receiverId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? kBlack.withOpacity(.5) : kPriemryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          data['message'],
          style: kSmallTitle1,
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration:   BoxDecoration(
                color: kPriemryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}