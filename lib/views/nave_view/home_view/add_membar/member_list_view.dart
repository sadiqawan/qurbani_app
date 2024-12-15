import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';
import '../home_controller.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({super.key});

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member List'),
        backgroundColor: kPriemryColor,
        centerTitle: true,
        titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: homeController.getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No members found'),
            );
          }

          final members = snapshot.data!.docs;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final memberData = members[index].data();
              final memberName = memberData['memberName'] ?? 'Unknown';
              final memberNumber = memberData['memberNumber'] ?? 'N/A';
              final memberImage = memberData['picture'];

              return ListTile(
                leading: memberImage != null
                    ? CircleAvatar(
                  maxRadius: 30.sp,
                  backgroundImage: NetworkImage(memberImage),
                )
                    : CircleAvatar(
                  maxRadius: 30.sp,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  memberName,
                  style: kSmallTitle1B,
                ),
                subtitle: Text(
                  'Relation: $memberNumber',
                  style: kSmallTitle1,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('members')
                          .doc(members[index].id)
                          .delete();
                      Get.snackbar(
                        "Success",
                        "Member deleted successfully",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to delete member: $e",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
