import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/views/nave_view/home_view/post_view.dart';
import 'package:medally_pro/views/nave_view/home_view/profile_view.dart';
import '../../../const/constant_colors.dart';


class HomeController extends GetxController {
  Rxn<File> image = Rxn<File>();
  String imageUrl = '';
  var isLoading = false.obs;
  var selectedMember = ''.obs;

  var itemsActionBar = [
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () {
        Get.to(() => const PostView());
      },
      child: Icon(Icons.medical_services_outlined, color: kWhit),
    ),
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () {
        Get.to(() => const ProfileView2());
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

}
