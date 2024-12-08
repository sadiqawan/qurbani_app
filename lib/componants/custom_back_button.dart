import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../const/constant_colors.dart';


class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 32.h,
      width: 37.w,
      decoration: BoxDecoration(
        color: kPriemryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios_new_outlined, color: kBlack),
      ),
    );
  }
}
