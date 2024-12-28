import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../const/constant_colors.dart';
import 'add_medicine_view/add_contant_view.dart';
import 'add_membar/add_membar.dart';

class HomeController extends GetxController {
  Rxn<File> image = Rxn<File>();
  String imageUrl = '';
  var isLoading = false.obs;
  var selectedMember = ''.obs;

  var itemsActionBar = [
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () {
        Get.to(() => const AddMedicineView());
      },
      child: Icon(Icons.medical_services_outlined, color: kWhit),
    ),
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () {
        Get.to(() => const AddMember());
      },
      child: Icon(Icons.person, color: kWhit),
    ),
  ];

  // Stream to get user data
  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDataStream() {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uId).snapshots();
  }

  // Function to pick an image from the source
  Future<void> pickImageFrom(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        image.value = File(pickedFile.path); // Update observable variable
      }
    } catch (e) {
      Get.snackbar('Error', 'Error picking image: $e',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
    }
  }

  // Function to add a member to the list
  Future<void> addMember(String memberName, String number) async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }
      final membersRef = FirebaseFirestore.instance
          .collection('usersMemberList')
          .doc(user.uid)
          .collection('members');
      String? uploadedImageUrl;
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref('usersMemberListImages/${user.uid}')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(image.value!);
        uploadedImageUrl = await storageRef.getDownloadURL();
      }

      await membersRef.add({
        'memberName': memberName,
        'memberNumber': number,
        'picture': uploadedImageUrl,
        'time': DateTime.now(),
      });

      Get.snackbar(
        "Success",
        "Member added successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );

      image.value = null; // Reset image after upload
      update();
    } catch (error) {
      Get.snackbar(
        'Error',
        '$error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Stream to get userMemberList data
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserDataStream() {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('usersMemberList')
        .doc(uId)
        .collection('members')
        .snapshots();
  }

  // Stream to get medicationData data
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserMedicationStream() {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('usersMemberList')
        .doc(uId)
        .collection('medication')
        .snapshots();
  }
}
