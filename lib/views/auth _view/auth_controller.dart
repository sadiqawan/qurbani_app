
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../nave_view/navbar_view.dart';
import 'login_view/login_view.dart';

class AuthController extends GetxController{


  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();
  final forgetC = TextEditingController();
  var isLoading = false.obs;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    super.dispose();
  }

// Method for user registration
  Future<void> signup() async {
    try {
      isLoading.value = true;

      // Create a new user with Firebase Authentication
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      // Store user data in Firestore
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'time': DateTime.now(),
        'name': nameC.text.trim(),
        'email': emailC.text.trim(),
        'picture': null,
      });
      // final SharedPreferences pref = await SharedPreferences.getInstance();
      // await pref.setString('name', nameC.text.trim());
      // await pref.setString('email', emailC.text.trim());
      Get.snackbar(
        "Success",
        "Successfully SignUp in",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );
      isLoading.value = false;
      Get.offAll(() => const LoginScreen());
    } catch (error) {
      isLoading.value = false;
      print(error.toString());
      Get.snackbar(
        'Error',
        '$error',
        backgroundColor: Colors.red.withOpacity(.3),
      );
    }
  }

// Login
  Future<void> login() async {
    try {
      isLoading.value = true;
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: emailC.text.trim(), password: passC.text.trim());
      Get.snackbar(
        "Success",
        "Successfully logged in",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );
      isLoading.value = false;
      Get.offAll(() => const BottomNavbarScreen());
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('is_login', true);
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Login Failed',
        'Error: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.3),
      );
      isLoading.value = false;
    }
  }
  // reset password

  Future<void> sendPasswordResetEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      isLoading.value = true;
      await auth.sendPasswordResetEmail(email: forgetC.text.trim());
      Get.snackbar(
        "Success",
        'Password reset email sent!${forgetC.text.trim()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(.3),
      );
      isLoading.value = false;
      Get.offAll(const LoginScreen());

    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        "Failed",
        'Failed to send password reset email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.3),
      );
      isLoading.value = false;

    }
  }

}