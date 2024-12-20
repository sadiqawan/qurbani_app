import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';
import '../home_controller.dart';

class MedicineHistoryView extends StatefulWidget {
  const MedicineHistoryView({super.key});

  @override
  State<MedicineHistoryView> createState() => _MedicineHistoryViewState();
}

class _MedicineHistoryViewState extends State<MedicineHistoryView> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Medicine History'),
    backgroundColor: kPriemryColor,
    centerTitle: true,
    titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
    ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: homeController.getUserMedicationStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Medicine Added yet'),
            );
          }

          final medication = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medication.length,
            itemBuilder: (context, index) {
              final medicationData = medication[index].data();
              final medicineName = medicationData['medicineName'] ?? 'Unknown';
              final drName = medicationData['doctorName'] ?? 'N/A';
              final medicinImage = medicationData['picture'];

              return ListTile(
                leading:  medicinImage!= null
                    ? CircleAvatar(
                  maxRadius: 30.sp,
                  backgroundImage: NetworkImage( medicinImage),
                )
                    : CircleAvatar(
                  maxRadius: 30.sp,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  medicineName,
                  style: kSmallTitle1B,
                ),
                subtitle: Text(
                  'Suggested By: $drName',
                  style: kSmallTitle1,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('medication')
                          .doc(medication[index].id)
                          .delete();
                      Get.snackbar(
                        "Success",
                        "Medication deleted successfully",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to delete medication: $e",
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
