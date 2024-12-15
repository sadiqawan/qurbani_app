import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/constant_colors.dart';

class CustomTextFeild extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyBordType;
  final bool? obscureText;
  final ValueChanged<String>? onSubmit;
  final int? maxLine;

  const CustomTextFeild({
    required this.hint,
    required this.controller,
    required this.icon,
    super.key,
    this.keyBordType,
    this.obscureText,
    this.onSubmit,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 53.h,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: kPriemryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        maxLines: maxLine ?? 1,
        onSubmitted: onSubmit,
        obscureText: obscureText ?? false,
        keyboardType: keyBordType,
        controller: controller,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
          hintStyle: GoogleFonts.poppins(
            fontSize: 15.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
