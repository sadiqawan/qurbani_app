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
  HomeController controller = Get.put(HomeController());
  TextEditingController nameCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  TextEditingController priceCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController breedCon = TextEditingController();

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Enter Animal Data',
                  style: kSmallTitle1.copyWith(
                      color: Colors.black, fontSize: 24.sp)),
              SizedBox(height: 30.h),
              _buildInputField(
                'Enter Name',
                nameCon,
                'Name',
                Icons.person,
              ),
              _buildInputField(
                'Enter Animal Type',
                nameCon,
                'Animal Type',
                Icons.person,
              ),
              _buildInputField('Enter Price', priceCon, 'Price', Icons.add,
                  isNumber: true),
              _buildInputField('Enter Animal Age', ageCon, 'Animal Age',
                  Icons.confirmation_num,
                  isNumber: true),
              _buildInputField(
                'Enter Breeding information',
                breedCon,
                'Breeding Info',
                Icons.mail_sharp,
              ),
              _buildInputField(
                'Enter Description',
                desCon,
                'Description',
                Icons.mail_sharp,
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Center(
                  child: SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Obx(() {
                      return controller.image.value == null
                          ? Icon(
                        Icons.medical_services_outlined,
                        size: 200,
                      )
                          : Image.file(
                        controller.image.value!,
                        fit: BoxFit.fill,
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
                                        controller
                                            .pickImageFrom(ImageSource.camera);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Flexible(
                                    child: CustomButton(
                                        title: 'Select Gallery',
                                        onTap: () {
                                          controller.pickImageFrom(
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
                    const Icon(
                      Icons.upload,
                      size: 30,
                    ),
                    Text(
                      'Upload Pic',
                      style: kSubTitle2B,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                title: 'Submit',
                onTap: () {},
              )
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
