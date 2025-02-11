import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/componants/custom_button.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import '../../../componants/custom_text_feild.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Post',
          style: kSmallTitle1.copyWith(
            color: Colors.black,
          ),
        ),
        backgroundColor: kPriemryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Enter Animal Data',
                style: kSmallTitle1.copyWith(
                  color: Colors.black,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 30.h),
              _buildInputField('Enter Name', controller.nameCon, 'Name', Icons.person),
              _buildInputField('Enter Animal Type', controller.breedCon, 'Animal Type', Icons.pets),
              _buildInputField('Enter Price', controller.priceCon, 'Price', Icons.attach_money, isNumber: true),
              _buildInputField('Enter Animal Age', controller.ageCon, 'Animal Age in Year', Icons.cake, isNumber: true),
              _buildInputField('Enter Animal Location', controller.locaCon, 'Animal Location', Icons.cake,  ),
              _buildInputField('Enter Your Contact', controller.contCon, 'Contact', Icons.cake, isNumber: true),
              _buildInputField('Enter Description', controller.desCon, 'Description', Icons.description, maxLines: 3),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Center(
                  child: SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Obx(() {
                      return controller.image.value == null
                          ? const Icon(Icons.image, size: 100, color: Colors.grey)
                          : Image.file(controller.image.value!, fit: BoxFit.cover);
                    }),
                  ),
                ),
              ),
              InkWell(
                onTap: _showImagePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload, size: 30),
                    Text('Upload Pic', style: kSubTitle2B),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() {
                return controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  title: 'Submit',
                  onTap: controller.postData,
                );
              }),
              SizedBox(height: 10.h,)
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker() {
    Get.bottomSheet(
      backgroundColor: kWhit,
      SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Upload Pic', style: kHeading2B),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: CustomButton(
                      title: 'Select Camera',
                      onTap: () {
                        controller.pickImageFrom(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: CustomButton(
                      title: 'Select Gallery',
                      onTap: () {
                        controller.pickImageFrom(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kSmallTitle1.copyWith(color: Colors.black)),
        SizedBox(height: 8.h),
        CustomTextFeild(
          obscureText: false,
          keyBordType: isNumber ? TextInputType.number : TextInputType.text,
          hint: hint,
          icon: icon,
          controller: controller,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
