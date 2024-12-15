import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import '../../../../componants/custom_button.dart';
import '../../../../componants/custom_text_feild.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController numeberController = TextEditingController();
    HomeController homeController = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
        backgroundColor: kPriemryColor,
        centerTitle: true,
        titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Add Your Member',
                  style: kHeading2B.copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Center(
                  child: SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Obx(() {
                      return homeController.image.value == null
                          ? Image.asset(
                              'assets/images/icon_profile.png', // Default image
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              homeController.image.value!,
                              fit: BoxFit.fill, // Adjust for better display
                            );
                    }),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                      backgroundColor: kWhit,
                      SizedBox(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload Pic',
                                style: kHeading2B,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      child: CustomButton(
                                          title: 'Select Camera',
                                          onTap: () {
                                            homeController.pickImageFrom(
                                                ImageSource.camera);
                                          })),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Flexible(
                                    child: CustomButton(
                                        title: 'Select Gallery',
                                        onTap: () {
                                          homeController.pickImageFrom(
                                              ImageSource.gallery);
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload Pic',
                      style: kSubTitle2B,
                    ),
                    const Icon(Icons.edit_outlined),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Enter your Member name: ',
                  style: kSmallTitle1.copyWith(color: Colors.black),
                ),
              ),
              CustomTextFeild(
                obscureText: false,
                keyBordType: TextInputType.text,
                hint: 'Member Name',
                icon: Icons.person,
                controller: nameController,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Enter Relation ',
                  style: kSmallTitle1.copyWith(color: Colors.black),
                ),
              ),
              CustomTextFeild(
                obscureText: false,
                hint: 'Relation',
                icon: Icons.person,
                controller: numeberController,
              ),
              SizedBox(height: 20.h),
              Obx(() {
                return homeController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                        color: kPriemryColor,
                      ))
                    : CustomButton(
                        title: 'Add Member',
                        onTap: () {
                          final name = nameController.text.trim();
                          final number = numeberController.text.trim();

                          if (name.isEmpty || number.isEmpty) {
                            Get.snackbar(
                              "Failed",
                              "Enter the required credentials",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red.withOpacity(.3),
                            );
                          } else {
                            homeController.addMember(name, number).then((_) {
                              nameController.clear();
                              numeberController.clear();
                            });
                          }
                        },
                      );
                ;
              })
            ],
          ),
        ),
      ),
    );
  }
}
