import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth _view/login_view/login_view.dart';


class ProfileViewController extends GetxController {
  File? image;
  String imageUrl = '';

  // Stream to get user data
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uId).snapshots();
  }

  // Function to pick an image from the source and upload it
  Future<void> pickImageFrom(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('${user.uid}.jpg');
          await storageRef.putFile(image);
          final imageUrl = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'picture': imageUrl});

          Get.snackbar("Success", "Image updated successfully",
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);
        } else {
          Get.snackbar('Error', 'User is not authenticated',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unauthorized') {
        Get.snackbar('Error', 'You are not authorized to perform this action',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Error: ${e.message}',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
      print("Firebase Exception: $e");
    } catch (e) {
      Get.snackbar('Error', 'Error: $e',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      print("Error picking image: $e");
    }
  }







// logout form current account

  Future<void> logout() async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signOut();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('is_login', false);
      Get.offAll(const LoginScreen());
      Get.snackbar(
        "Success",
        'Successfully logout!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );
    } catch (e) {
      Get.snackbar(
        "Failed",
        'Failed!${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.3),
      );
    }
  }
}
