import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import '../../../const/contant_style.dart';
import 'add_medicine_view/add_contant_view.dart';
import 'add_membar/add_membar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        items: homeController.itemsActionBar,
        color: kPriemryColor,
        icon: Icons.add,
        duration: const Duration(milliseconds: 200),
        curveAnim: Curves.ease,
        useOpacity: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Row(
              children: [
                userImage(),
                // CircleAvatar(
                //   maxRadius: 30.sp,
                //   backgroundColor: Colors.transparent,
                //   backgroundImage:
                //       const AssetImage("assets/images/icon_person.png"),
                // ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome To 👋", style: kSubTitle2B),
                    Text(
                      "MedallyPro",
                      style: kSubTitle2B.copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(child: SizedBox()),
            Text(
              'Your Members',
              style: kSmallTitle1,
            ),
            Expanded(child: memberList()),
          ],
        ),
      ),
    );
  }
}

Widget memberList() {
  final HomeController homeController = Get.put(HomeController());

  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
              'Number: $memberNumber',
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
  );
}

Widget userImage() {
  HomeController controller = Get.put(HomeController());
  return StreamBuilder(
      stream: controller.getCurrentUserDataStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        }
        var userData = snapshot.data?.data();
        if (userData == null || userData['picture'] == null) {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
          //   CircleAvatar(
          //   radius: screenWidth * 0.06,
          //   backgroundImage: const AssetImage("assets/images/profile.png"),
          // );
        } else {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundImage: NetworkImage(userData!['picture']),
          );
        }
      });
}
