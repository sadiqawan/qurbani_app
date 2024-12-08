import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/constant_colors.dart';
import '../const/contant_style.dart';



class CustomButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final VoidCallback onTap;
  final Color? color;

  const CustomButton(
      {super.key,
      required this.title,
      this.width,
      this.height,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 48.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? kPriemryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          title,
          style: kSubTitle2B
        )),
      ),
    );
  }
}
