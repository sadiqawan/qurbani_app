import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicineController extends GetxController {
  Rxn<File> image = Rxn<File>();
  var isLoading = false.obs;

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

  // Function to add medicine to Firestore
  Future<void> addMedicine(
      {required String medicineName,
      required String strength,
      required String memberName,
      String? note,
      String? doctorName,
      required String duration,
      required String intakePerDay,
      required String reminderTime,
      required int remain}) async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final medicationRef = FirebaseFirestore.instance
          .collection('usersMemberList')
          .doc(user.uid)
          .collection('medication');

      String? uploadedImageUrl;

      if (image.value != null) {
        final storageRef = FirebaseStorage.instance
            .ref('medication/${user.uid}')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(image.value!);
        uploadedImageUrl = await storageRef.getDownloadURL();
      }

      await medicationRef.add({
        'medicineName': medicineName,
        'strength': strength,
        'note': note,
        'doctorName': doctorName,
        'duration': duration,
        'intakePerDay': intakePerDay,
        'reminderTime': reminderTime,
        'memberName': memberName,
        'picture': uploadedImageUrl,
        'remainingDose': remain,
      });

      Get.snackbar(
        "Success",
        "Medicine added successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );

      image.value = null; // Reset image after upload
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

  Future<void> updateMedicine({
    required String
        documentId, // Include document ID for updating specific records
    required String medicineName,
    required String strength,
    required String memberName,
    String? note,
    String? doctorName,
    required String duration,
    required String intakePerDay,
    required String reminderTime,
  }) async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final medicationRef = FirebaseFirestore.instance
          .collection('usersMemberList')
          .doc(user.uid)
          .collection('medication')
          .doc(documentId); // Specify the document to update

      String? uploadedImageUrl;

      if (image.value != null) {
        final storageRef = FirebaseStorage.instance
            .ref('medication/${user.uid}')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(image.value!);
        uploadedImageUrl = await storageRef.getDownloadURL();
      }

      await medicationRef.set({
        'medicineName': medicineName,
        'strength': strength,
        'note': note,
        'doctorName': doctorName,
        'duration': duration,
        'intakePerDay': intakePerDay,
        'reminderTime': reminderTime,
        'memberName': memberName,
        if (uploadedImageUrl != null) 'picture': uploadedImageUrl,
      }, SetOptions(merge: true)); // Merge updates with existing data

      Get.snackbar(
        "Success",
        "Medicine details updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );

      image.value = null; // Reset image after upload
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to update medicine: $error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicineController extends GetxController{

  Rxn<File> image = Rxn<File>();
  String imageUrl = '';
  var isLoading = false.obs;
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
          .collection('medication');

      String? uploadedImageUrl;

      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref('medication/${user.uid}')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(image.value! );
        uploadedImageUrl = await storageRef.getDownloadURL();
      }

      await membersRef.add({
        'medicineName': medicineName,
        'strength': number,

        'picture': uploadedImageUrl,

        'doctorName': medicineTime,
        'duration': medicineTime,
        'intakePerDay': medicineTime,
        'RemainderTime': medicineTime,

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

}*/
