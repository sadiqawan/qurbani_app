import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import '../../const/constant_colors.dart';
import '../../const/contant_style.dart';
import '../auth _view/login_view/login_view.dart';
import '../nave_view/navbar_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogggedIn();
  }

  checkIfAlreadyLogggedIn() async {
    var pref = await SharedPreferences.getInstance();

    var v = pref.get("is_login");

    if (v == true && v != null) {
      Timer(
        const Duration(seconds: 5),
        () => Get.to(const BottomNavbarScreen()),
      );
    } else {
      Timer(const Duration(seconds: 5), () => Get.to(const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPriemryColor.withOpacity(.9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 180.w,
                  height: 180.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/medical-icon.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                FadeOutParticle(
                  curve: Curves.bounceIn,
                  duration: const Duration(seconds: 5),
                  disappear: true,
                  child: Text(
                    'MediallyPro',
                    style: kSubTitle2B.copyWith(fontSize: 38.sp),
                  ),
                )
              ],
            ),
            // Your splash image
          ],
        ),
      ),
    );
  }
}
