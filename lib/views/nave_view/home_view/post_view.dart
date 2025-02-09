import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../componants/custom_text_feild.dart';
import '../../../const/contant_style.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  TextEditingController priceCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              Text('Enter Animal Data',
                  style: kSmallTitle1.copyWith(color: Colors.black,fontSize: 24.sp)),
              SizedBox(height: 30.h),

          
              _buildInputField(
                'Enter Name',
                nameCon,
                'Name',
                Icons.person,
              ),_buildInputField(
                'Enter Animal Type',
                nameCon,
                'Animal Type',
                Icons.person,
              ),
              _buildInputField(
          
                'Enter Price',
                priceCon,
                'Price',
                Icons.add,
                isNumber: true
              ), _buildInputField(
          
                'Enter Animal Age',
                priceCon,
                'Animal Age',
                Icons.add,
                isNumber: true
              ), _buildInputField(
                'Enter Description',
                desCon,
                'Description',
                Icons.mail_sharp,

              ),
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
