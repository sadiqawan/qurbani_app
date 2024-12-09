import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/auth%20_view/auth_controller.dart';
import '../../../componants/custom_back_button.dart';
import '../../../componants/custom_button.dart';
import '../../../componants/custom_text_feild.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';
import '../login_view/login_view.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
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
                SizedBox(height: 20.h),
                Text('Register', style: kHeading2B),
                SizedBox(height: 8.h),
                Text('Create your new account', style: kSmallTitle1),
                SizedBox(height: 15.h),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    children: [
                      CustomTextFeild(
                        hint: 'Full Name',
                        controller: authController.nameC,
                        icon: Icons.person,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFeild(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: authController.emailC,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFeild(
                        obscureText: true,
                        hint: 'Password',
                        icon: Icons.lock,
                        controller: authController.passC,
                      ),
                      SizedBox(height: 20.h),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            wordSpacing: 2.sp,
                          ),
                          children: [
                            TextSpan(
                                text: 'By Signing you agree to our ',
                                style: kSmallTitle1.copyWith(fontSize: 12.sp)),
                            TextSpan(
                                text: 'Team of use ',
                                style: kSmallTitle1.copyWith(
                                    fontSize: 12.sp, color: kPriemryColor)),
                            TextSpan(
                                text: 'and ',
                                style: kSmallTitle1.copyWith(fontSize: 12.sp)),
                            TextSpan(
                                text: 'Privacy notice.',
                                style: kSmallTitle1.copyWith(
                                    fontSize: 13.sp, color: kPriemryColor)),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 126.h),
                          child: Obx(
                            () => authController.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: kPriemryColor,
                                  ))
                                : CustomButton(
                                    title: 'SignUp',
                                    onTap: () {
                                      if (authController.nameC.text.isEmpty ||
                                          authController.emailC.text.isEmpty ||
                                          authController.passC.text.isEmpty) {
                                        Get.snackbar(
                                          'Failed',
                                          'Error: Enter valid Credentials',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor:
                                              Colors.red.withOpacity(.3),
                                        );
                                      } else {
                                        authController.signup();
                                      }
                                    },
                                  ),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account!', style: kSmallTitle1),
                          SizedBox(width: 5.w),
                          InkWell(
                            child: Text("Login here",
                                style: kSubTitle2B.copyWith(fontSize: 15.sp)),
                            onTap: () {
                              Get.offAll(() => const LoginScreen());
                            },
                          )
                        ],
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
