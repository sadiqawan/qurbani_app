import 'package:flutter/material.dart';

import '../const/constant_colors.dart';
import '../const/contant_style.dart';

class ConstantContainer extends StatefulWidget {
  final String text;
  final IconData iconData;

  VoidCallback onTap;

  ConstantContainer(
      {super.key, required this.text, required this.iconData, required this.onTap});

  @override
  State<ConstantContainer> createState() => _ConstantContainerState();
}

class _ConstantContainerState extends State<ConstantContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: kPriemryColor,
        ),
        child: Column(
          children: [
            Center(child: Icon(widget.iconData,size: 150,)),
            Text(widget.text, style: kSmallTitle1B,)
          ],
        ),
      ),
    );
  }
}
