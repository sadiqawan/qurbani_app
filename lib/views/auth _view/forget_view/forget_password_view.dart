import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../componants/custom_back_button.dart';
import '../../../componants/custom_button.dart';
import '../../../componants/custom_text_feild.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';
import '../auth_controller.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 280),
                  child: CustomBackButton(),
                ),
                SizedBox(height: 100.h),
                Text('Forget Password', style: kHeading2B),
                SizedBox(height: 8.h),
                Text('Enter your Valid Email', style: kSmallTitle1),
                SizedBox(height: 70.h),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: [

                      SizedBox(height: 10.h),
                      CustomTextFeild(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: authController.forgetC,
                      ),

                      Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Obx(
                                () => authController.isLoading.value
                                ? Center(
                                child: CircularProgressIndicator(
                                  color: kPriemryColor,
                                ))
                                : CustomButton(
                              title: 'Send',
                              onTap: () {
                                if(authController.forgetC.text.isEmpty){
                                  Get.snackbar(
                                    'Failed',
                                    'Error: Enter valid Email',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red.withOpacity(.3),
                                  );
                                }else{
                                  authController.sendPasswordResetEmail();
                                }


                              },
                            ),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
