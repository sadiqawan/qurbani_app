import 'dart:io';

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

}