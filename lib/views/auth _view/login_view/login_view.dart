import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/auth%20_view/registration_view/registration_view.dart';
import '../../../componants/custom_button.dart';
import '../../../componants/custom_text_feild.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';
import '../auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: _BottomCurveClipper(),
                    child: Image.asset(
                      'assets/images/medical-icon.png',
                      width: 180.w,
                      height: 180.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.h, bottom: 20),
                child: Text('Welcome Back', style: kHeading2B),
              ),
              Text('Login into your account', style: kSmallTitle1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  children: [
                    CustomTextFeild(
                      keyBordType: TextInputType.emailAddress,
                      hint: 'Email',
                      icon: Icons.person,
                      controller: authController.emailC,
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFeild(
                      obscureText: true,
                      keyBordType: TextInputType.text,
                      hint: 'Password',
                      icon: Icons.lock,
                      controller: authController.passC,
                    ),
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        child: Text('Forgot Password?', style: kSmallTitle1),
                        onTap: () {
                          // Get.to(() => const ForgetPasswordScreen());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Obx(() {
                        return authController.isLoading.value
                            ? Center(
                            child: CircularProgressIndicator(
                              color: kPriemryColor,
                            ))
                            : CustomButton(
                            title: 'Login',
                            height: 48.h,
                            onTap: () {
                              if (authController.emailC.text.isEmpty ||
                                  authController.passC.text.isEmpty) {
                                Get.snackbar(
                                  'Failed',
                                  'Error: Enter valid Credentials',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:
                                  Colors.red.withOpacity(.3),
                                );
                              } else {
                                authController.login();
                              }
                            }
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?',
                            style: kSubTitle1.copyWith(fontSize: 12.sp)),
                        SizedBox(width: 5.w),
                        InkWell(
                          child: Text("Sign Up",
                              style: kSubTitle2B.copyWith(fontSize: 12.sp)),
                          onTap: () {
                            Get.to(() => const RegistrationView());
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
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 70);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
